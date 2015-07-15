-- highlandpools 0.1.1 by paramat
-- For latest stable Minetest back to 0.4.8
-- Depends default
-- Licenses: code WTFPL

-- Parameters

local YMAX = 64 -- Maximum altitude for pools
local FLOW = 256

-- Stuff

highlandpools = {}

-- Functions

function highlandpools_remtree(x, y, z, area, data)
	local c_tree = minetest.get_content_id("default:tree")
	local c_apple = minetest.get_content_id("default:apple")
	local c_leaves = minetest.get_content_id("default:leaves")
	local c_air = minetest.get_content_id("air")
	for j = 1, 7 do
	for i = -2, 2 do
	for k = -2, 2 do
		local vi = area:index(x+i, y+j, z+k)
		if data[vi] == c_tree
		or data[vi] == c_apple
		or data[vi] == c_leaves then
			data[vi] = c_air
		end
	end
	end
	end
	for j = 1, 7 do
	for i = -2, 2 do
	for k = -2, 2 do
		local vi = area:index(x+i, y-j, z+k)
		if data[vi] == c_tree
		or data[vi] == c_apple
		or data[vi] == c_leaves then
			data[vi] = c_air
		end
	end
	end
	end
end

-- On generated function

minetest.register_on_generated(function(minp, maxp, seed)
	local y0 = minp.y
	if y0 < -32 or y0 > YMAX then
		return
	end
	
	local t1 = os.clock()
	local x0 = minp.x
	local z0 = minp.z
	-- print ("[highlandpools] chunk ("..x0.." "..y0.." "..z0..")")
	local x1 = maxp.x
	local y1 = maxp.y
	local z1 = maxp.z
	local sidelen = x1 - x0 -- actually sidelen - 1
	
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local c_watsour = minetest.get_content_id("default:water_source")
	local c_grass = minetest.get_content_id("default:dirt_with_grass")
	local c_tree = minetest.get_content_id("default:tree")
	local c_apple = minetest.get_content_id("default:apple")
	local c_leaves = minetest.get_content_id("default:leaves")
	local c_dirt = minetest.get_content_id("default:dirt")
	
	for xcen = x0 + 8, x1 - 7, 8 do
	for zcen = z0 + 8, z1 - 7, 8 do
		local yasurf = false -- y of above surface node
		for y = y1, 2, -1 do
			local vi = area:index(xcen, y, zcen)
			local c_node = data[vi]
			if y == y1 and c_node ~= c_air then -- if top node solid
				break
			elseif c_node == c_watsour then
				break
			elseif c_node == c_grass then
				yasurf = y + 1
				break
			end
		end
		if yasurf then
			local abort = false
			for ser = 1, 80 do
				local vi = area:index(xcen + ser, yasurf, zcen)
				local c_node = data[vi]
				if xcen + ser == x1 then
					abort = true
				elseif c_node ~= c_air
				and c_node ~= c_tree
				and c_node ~= c_leaves
				and c_node ~= c_apple then
					break
				end
			end
			for ser = 1, 80 do
				local vi = area:index(xcen - ser, yasurf, zcen)
				local c_node = data[vi]
				if xcen - ser == x0 then
					abort = true
				elseif c_node ~= c_air
				and c_node ~= c_tree
				and c_node ~= c_leaves
				and c_node ~= c_apple then
					break
				end
			end
			for ser = 1, 80 do
				local vi = area:index(xcen, yasurf, zcen + ser)
				local c_node = data[vi]
				if zcen + ser == z1 then
					abort = true
				elseif c_node ~= c_air
				and c_node ~= c_tree
				and c_node ~= c_leaves
				and c_node ~= c_apple then
					break
				end
			end
			for ser = 1, 80 do
				local vi = area:index(xcen, yasurf, zcen - ser)
				local c_node = data[vi]
				if zcen - ser == z0 then
					abort = true
				elseif c_node ~= c_air
				and c_node ~= c_tree
				and c_node ~= c_leaves
				and c_node ~= c_apple then
					break
				end
			end
			if abort then
				break
			end
			
			local vi = area:index(xcen, yasurf, zcen)
			data[vi] = c_watsour
			local flab = false -- flow abort
			for flow = 1, FLOW do
				for z = z0, z1 do
					for x = x0, x1 do
						local vif = area:index(x, yasurf, z)
						if data[vif] == c_watsour then
							if x == x0 or x == x1 or z == z0 or z == z1 then
								flab = true -- if water at chunk edge abort flow
								break
							else -- flow water
								local vie = area:index(x + 1, yasurf, z)
								local viw = area:index(x - 1, yasurf, z)
								local vin = area:index(x, yasurf, z + 1)
								local vis = area:index(x, yasurf, z - 1)
								if data[vie] == c_tree then
									highlandpools_remtree(x + 1, yasurf, z, area, data)
									data[vie] = c_watsour
								elseif data[vie] == c_air
								or data[vie] == c_apple
								or data[vie] == c_leaves then
									data[vie] = c_watsour
								end
								if data[viw] == c_tree then
									highlandpools_remtree(x - 1, yasurf, z, area, data)
									data[viw] = c_watsour
								elseif data[viw] == c_air
								or data[viw] == c_apple
								or data[viw] == c_leaves then
									data[viw] = c_watsour
								end
								if data[vin] == c_tree then
									highlandpools_remtree(x, yasurf, z + 1, area, data)
									data[vin] = c_watsour
								elseif data[vin] == c_air
								or data[vin] == c_apple
								or data[vin] == c_leaves then
									data[vin] = c_watsour
								end
								if data[vis] == c_tree then
									highlandpools_remtree(x, yasurf, z - 1, area, data)
									data[vis] = c_watsour
								elseif data[vis] == c_air
								or data[vis] == c_apple
								or data[vis] == c_leaves then
									data[vis] = c_watsour
								end
							end
						end
					end
					if flab then
						break
					end
				end
				if flab then
					break
				end
			end
			if flab then -- erase water from this y level
				for z = z0, z1 do
				for x = x0, x1 do
					local vi = area:index(x, yasurf, z)
					if data[vi] == c_watsour then
						data[vi] = c_air
					end
				end
				end
			else -- flow downwards add dirt
				for z = z0, z1 do
				for x = x0, x1 do
					local vi = area:index(x, yasurf, z)
					if data[vi] == c_watsour then
						for y = yasurf - 1, y0, -1 do
							local viu = area:index(x, y, z)
							if data[viu] == c_air then
								data[viu] = c_watsour
							elseif data[viu] == c_grass then
								data[viu] = c_dirt
								break
							else
								break
							end
						end
					end
				end
				end
			end
		end
	end
	end
	
	vm:set_data(data)
	vm:set_lighting({day=0, night=0})
	vm:calc_lighting()
	vm:write_to_map(data)
	
	local chugent = math.ceil((os.clock() - t1) * 1000)
	-- print ("[highlandpools] time "..chugent.." ms")
end)
