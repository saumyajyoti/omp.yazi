-- async mode
-------------------------------------------------------------------------------

local save = ya.sync(function(st, cwd, output)
	if cx.active.current.cwd == Url(cwd) then
		st.output = output
		ya.render()
	end
end)

return {
	setup = function(st)
		Header.cwd = function()
			local cwd = cx.active.current.cwd
			if st.cwd ~= cwd then
				st.cwd = cwd
				ya.manager_emit("plugin", { st._name, args = ya.quote(tostring(cwd), true) })
			end

			return ui.Line.parse(st.output or "")
		end
	end,

	entry = function(_, args)
		local output = Command("oh-my-posh"):args({ "print", "primary" }):cwd(args[1]):output()
		if output then
			save(args[1], output.stdout:gsub("^%s+", ""))
		end
	end,
}

---------------------------------------------------------------------------------------
-- sync mode
---------------------------------------------------------------------------------------
-- return {
-- setup = function(st)
-- Header.cwd = function()
-- local cwd = cx.active.current.cwd
-- if st.cwd ~= cwd then
-- st.cwd, st.output = cwd, io.popen("oh-my-posh print primary"):read("*a"):gsub("^%s+", "")
-- end
-- return ui.Line.parse(st.output)
-- end
-- end,
-- }
