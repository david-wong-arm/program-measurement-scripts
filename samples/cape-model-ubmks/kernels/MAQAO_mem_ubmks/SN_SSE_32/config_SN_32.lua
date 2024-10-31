session = {
   mode = "memory_bench", -- "insn_bench" or "memory_bench"
   kernelgen_method = "arch_dependent", -- "default" or "arch_dependent"

   compiler = {                      -- The compiler options and flags
      CCEnv = "",            -- Script loading the compiler environment
      CC = "gcc",                    -- The compiler to use
      Cflags = "-O2 -march=native",  -- Compilation flags
      LDflags = " ",                 -- Linking flags
   },

   instruction_sets = {         -- Instructions sets that must be forced in/out during generation
      blacklist = {},           -- Ex: { "SSE" } to skip SSE-based kernels even if could be generated
      whitelist = {},           -- Ex: { "AVX2" } to generate AVX2-based kernels even if not executable
   },

   experiment = {              -- Parameters of the experiment
      rootdir = "SN_32",       -- Target directory for all the experiments, if not set then auto generated
      kerneldir = "kernel",    -- Target directory for generated assembly kernels, if not set then auto generated
      driverdir = "driver",    -- Target directory for generated C drivers, if not set then auto generated
      bindir = "bin"           -- Target directory for generated binary benchmarks, if not set then auto generated
   },

   -- Parameters of the memory benchmark
   memory_bench_spec = {
      deffile = "../insns.csv",
      offset = { 0, 64, 128, 192 }, -- cacheline offset (in bytes) to use for each stream
      stride = 640, -- wished (constraint from unroll factor...) loop stride in bytes
      unroll_interleave = false, -- true to iterate over streams before unroll factor

      -- Memory access patterns
      patterns = { "1_L_32_F_U_1", -- 1 load stream, not unrolled
                   "1_L_32_F_U_2", -- 1 load stream, 2x unrolled
		   "1_L_32_F_U_4", -- 1	load stream, 4x	unrolled
                   "[1_L,2_L]_32_F_U_1", -- 2 load streams, not unrolled
                   "[1_L,2_L]_32_F_U_2", -- 2 load streams, 2x unrolled
                   "[1_L,2_L]_32_F_U_4", -- 2 load streams, 4x unrolled
                   "[1_L,2_L,3_L]_32_F_U_1", -- 3 load streams, not unrolled
                   "[1_L,2_L,3_L]_32_F_U_2", -- 3 load streams, 2x unrolled
                   "[1_L,2_L,3_L]_32_F_U_4", -- 3 load streams, 4x unrolled

      },

      -- Auto-detected values: please check
      -- L1: 32 KB (Data), core-private
      -- L2: 256 KB (Unified), core-private
      -- L3: 45 MB (Unified), core-shared
      -- RAM: kernel footprint must exceed 2 socket(s) x 45.00 MB LLCs
      streams = {
         { size=15000, label="L1", repw=6666660, repm=660, metarep=31 },
         { size=117000, label="L2", repw=854700, repm=80, metarep=31 },
         { size=11000000, label="L3", repw=9090, repm=10, metarep=31 },
         { size=141000000, label="RAM", repw=700, repm=10, metarep=31 }
      },
      
      adjust_streams_size = true, -- Adjust size according to streams number
      adjust_streams_rep  = false, -- Adjust repetitions according to streams number

      metric = "CPIT",   -- CPIT (Cycles Per ITeration), or BPC (Bytes Per Cycles)
      output = "TXT", -- TXT or CQATAB
   },
}
