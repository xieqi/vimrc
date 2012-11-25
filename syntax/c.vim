syn match Function "\<\zs\w\{-1,}\ze\s*(\_.\{-})"
syn keyword cType       UINT INT UINT8 INT8 UINT16 INT16 UINT32 INT32 UINT64 INT64 CHAR WCHAR TCHAR
syn keyword cType       uint uint8 int8 uint16 int16 uint32 int32 uint64 int64 wchar tchar f32 f64 vec_f32_t u_int32_t
syn keyword cType       TEXT INLINE NOINLINE
