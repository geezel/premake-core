--
-- tests/actions/vstudio/vc2010/test_debug_settings.lua
-- Validate handling of the working directory for debugging.
-- Copyright (c) 2011-2013 Jason Perkins and the Premake project
--

	local suite = test.declare("vstudio_vs2010_debug_settings")
	local vc2010 = premake.vstudio.vc2010
	local project = premake.project


--
-- Setup
--

	local sln, prj

	function suite.setup()
		sln, prj = test.createsolution()
	end

	local function prepare()
		local cfg = test.getconfig(prj, "Debug")
		vc2010.debugSettings(cfg)
	end


--
-- If no debug directory is set, nothing should be output.
--

	function suite.noOutput_onNoDebugDir()
		prepare()
		test.isemptycapture()
	end

--
-- The debug command should specified relative to the project location.
--

	function suite.debugCommand_isProjectRelative()
		debugcommand "bin/emulator.exe"
		prepare()
		test.capture [[
<LocalDebuggerCommand>bin\emulator.exe</LocalDebuggerCommand>
<DebuggerFlavor>WindowsLocalDebugger</DebuggerFlavor>
		]]
	end


--
-- The debug directory should specified relative to the project location.
--

	function suite.debugDirectory_isProjectRelative()
		debugdir "bin/debug"
		prepare()
		test.capture [[
<LocalDebuggerWorkingDirectory>bin\debug</LocalDebuggerWorkingDirectory>
<DebuggerFlavor>WindowsLocalDebugger</DebuggerFlavor>
		]]
	end

--
-- Verify handling of debug arguments.
--

	function suite.debuggerCommandArgs_onDebugArgs()
		debugargs { "arg1", "arg2" }
		prepare()
		test.capture [[
<LocalDebuggerCommandArguments>arg1 arg2</LocalDebuggerCommandArguments>
		]]
	end

--
-- Check the handling of debug environment variables.
--

	function suite.localDebuggerEnv_onDebugEnv()
		debugenvs { "key=value" }
		prepare()
		test.capture [[
<LocalDebuggerEnvironment>key=value</LocalDebuggerEnvironment>
		]]
	end

--
-- Multiple environment variables should be separated by a "\n" sequence.
--

	function suite.localDebuggerEnv_onDebugEnv()
		debugenvs { "key=value", "foo=bar" }
		prepare()
		test.capture [[
<LocalDebuggerEnvironment>key=value
foo=bar</LocalDebuggerEnvironment>
		]]
	end

