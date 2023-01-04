%lang starknet


from starkware.cairo.common.uint256 import Uint256, uint256_lt
from warplib.maths.int_conversions import warp_uint256
from starkware.cairo.common.alloc import alloc
from warplib.maths.external_input_check_address import warp_external_input_check_address
from warplib.maths.external_input_check_ints import warp_external_input_check_int256, warp_external_input_check_int8, warp_external_input_check_int32, warp_external_input_check_int96
from warplib.maths.external_input_check_bool import warp_external_input_check_bool
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from warplib.maths.eq import warp_eq
from warplib.maths.bytes_conversions import warp_bytes_widen_256


struct FacetAddressAndPosition_80522e2c{
    facetAddress : felt,
    functionSelectorPosition : felt,
}


struct FacetFunctionSelectors_ba2cb0c5{
    functionSelectors : felt,
    facetAddressPosition : Uint256,
}


struct Storage_14a18fd6{
    treasury : Uint256,
    budget : Uint256,
    period : Uint256,
    governanceToken : felt,
    governor : felt,
    availableRights : felt,
    highestDeadline : felt,
    dividends : felt,
    rightsOrigin : felt,
    rightUri : felt,
    dailyPrice : felt,
    maxRightsHolders : felt,
    maxtime : felt,
    rightsOver : felt,
    properties : felt,
    isAvailable : felt,
    owner : felt,
    rightHolders : felt,
    deadline : felt,
    rightsPeriod : felt,
    validated : felt,
    selectorToFacetAndPosition : felt,
    facetFunctionSelectors : felt,
    facetAddresses : felt,
    supportedInterfaces : felt,
    contractOwner : felt,
}


struct cd_dynarray_Uint256{
     len : felt ,
     ptr : Uint256*,
}

struct cd_dynarray_felt{
     len : felt ,
     ptr : felt*,
}

func WS_STRUCT_FacetAddressAndPosition_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt){
   alloc_locals;
    WS1_DELETE(loc);
    WS2_DELETE(loc + 1);
   return ();
}

func WS1_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS2_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WARP_DARRAY1_felt_IDX{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(ref: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (length) = WARP_DARRAY1_felt_LENGTH.read(ref);
    let (inRange) = uint256_lt(index, length);
    assert inRange = 1;
    let (existing) = WARP_DARRAY1_felt.read(ref, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_DARRAY1_felt.write(ref, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

func WSM0_Storage_14a18fd6_treasury(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WSM1_Storage_14a18fd6_budget(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WSM2_Storage_14a18fd6_period(loc: felt) -> (memberLoc: felt){
    return (loc + 4,);
}

func WSM3_Storage_14a18fd6_governanceToken(loc: felt) -> (memberLoc: felt){
    return (loc + 6,);
}

func WSM4_Storage_14a18fd6_governor(loc: felt) -> (memberLoc: felt){
    return (loc + 7,);
}

func WSM5_Storage_14a18fd6_availableRights(loc: felt) -> (memberLoc: felt){
    return (loc + 8,);
}

func WSM6_Storage_14a18fd6_highestDeadline(loc: felt) -> (memberLoc: felt){
    return (loc + 9,);
}

func WSM7_Storage_14a18fd6_dividends(loc: felt) -> (memberLoc: felt){
    return (loc + 10,);
}

func WSM8_Storage_14a18fd6_rightsOrigin(loc: felt) -> (memberLoc: felt){
    return (loc + 11,);
}

func WSM9_Storage_14a18fd6_rightUri(loc: felt) -> (memberLoc: felt){
    return (loc + 12,);
}

func WSM10_Storage_14a18fd6_dailyPrice(loc: felt) -> (memberLoc: felt){
    return (loc + 13,);
}

func WSM11_Storage_14a18fd6_maxRightsHolders(loc: felt) -> (memberLoc: felt){
    return (loc + 14,);
}

func WSM12_Storage_14a18fd6_maxtime(loc: felt) -> (memberLoc: felt){
    return (loc + 15,);
}

func WSM13_Storage_14a18fd6_rightsOver(loc: felt) -> (memberLoc: felt){
    return (loc + 16,);
}

func WSM14_Storage_14a18fd6_properties(loc: felt) -> (memberLoc: felt){
    return (loc + 17,);
}

func WSM15_Storage_14a18fd6_isAvailable(loc: felt) -> (memberLoc: felt){
    return (loc + 18,);
}

func WSM16_Storage_14a18fd6_owner(loc: felt) -> (memberLoc: felt){
    return (loc + 19,);
}

func WSM17_Storage_14a18fd6_rightHolders(loc: felt) -> (memberLoc: felt){
    return (loc + 20,);
}

func WSM18_Storage_14a18fd6_deadline(loc: felt) -> (memberLoc: felt){
    return (loc + 21,);
}

func WSM19_Storage_14a18fd6_rightsPeriod(loc: felt) -> (memberLoc: felt){
    return (loc + 22,);
}

func WSM20_Storage_14a18fd6_validated(loc: felt) -> (memberLoc: felt){
    return (loc + 23,);
}

func WSM22_Storage_14a18fd6_selectorToFacetAndPosition(loc: felt) -> (memberLoc: felt){
    return (loc + 24,);
}

func WSM25_Storage_14a18fd6_facetFunctionSelectors(loc: felt) -> (memberLoc: felt){
    return (loc + 25,);
}

func WSM27_Storage_14a18fd6_facetAddresses(loc: felt) -> (memberLoc: felt){
    return (loc + 26,);
}

func WSM28_Storage_14a18fd6_supportedInterfaces(loc: felt) -> (memberLoc: felt){
    return (loc + 27,);
}

func WSM29_Storage_14a18fd6_contractOwner(loc: felt) -> (memberLoc: felt){
    return (loc + 28,);
}

func WSM21_FacetAddressAndPosition_80522e2c_facetAddress(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WSM23_FacetAddressAndPosition_80522e2c_functionSelectorPosition(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WSM24_FacetFunctionSelectors_ba2cb0c5_functionSelectors(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WSM26_FacetFunctionSelectors_ba2cb0c5_facetAddressPosition(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WS0_READ_warp_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: felt){
    alloc_locals;
    let (read0) = readId(loc);
    return (read0,);
}

func WS1_READ_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: felt){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
}

func WS2_READ_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: Uint256){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    let (read1) = WARP_STORAGE.read(loc + 1);
    return (Uint256(low=read0,high=read1),);
}

func ws_dynamic_array_to_calldata0_write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(
   loc : felt,
   index : felt,
   len : felt,
   ptr : Uint256*) -> (ptr : Uint256*){
   alloc_locals;
   if (len == index){
       return (ptr,);
   }
   let (index_uint256) = warp_uint256(index);
   let (elem_loc) = WARP_DARRAY0_Uint256.read(loc, index_uint256);
   let (elem) = WS2_READ_Uint256(elem_loc);
   assert ptr[index] = elem;
   return ws_dynamic_array_to_calldata0_write(loc, index + 1, len, ptr);
}
func ws_dynamic_array_to_calldata0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt) -> (dyn_array_struct : cd_dynarray_Uint256){
   alloc_locals;
   let (len_uint256) = WARP_DARRAY0_Uint256_LENGTH.read(loc);
   let len = len_uint256.low + len_uint256.high*128;
   let (ptr : Uint256*) = alloc();
   let (ptr : Uint256*) = ws_dynamic_array_to_calldata0_write(loc, 0, len, ptr);
   let dyn_array_struct = cd_dynarray_Uint256(len, ptr);
   return (dyn_array_struct,);
}

func ws_dynamic_array_to_calldata1_write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(
   loc : felt,
   index : felt,
   len : felt,
   ptr : Uint256*) -> (ptr : Uint256*){
   alloc_locals;
   if (len == index){
       return (ptr,);
   }
   let (index_uint256) = warp_uint256(index);
   let (elem_loc) = WARP_DARRAY0_Uint256.read(loc, index_uint256);
   let (elem) = WS2_READ_Uint256(elem_loc);
   assert ptr[index] = elem;
   return ws_dynamic_array_to_calldata1_write(loc, index + 1, len, ptr);
}
func ws_dynamic_array_to_calldata1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt) -> (dyn_array_struct : cd_dynarray_Uint256){
   alloc_locals;
   let (len_uint256) = WARP_DARRAY0_Uint256_LENGTH.read(loc);
   let len = len_uint256.low + len_uint256.high*128;
   let (ptr : Uint256*) = alloc();
   let (ptr : Uint256*) = ws_dynamic_array_to_calldata1_write(loc, 0, len, ptr);
   let dyn_array_struct = cd_dynarray_Uint256(len, ptr);
   return (dyn_array_struct,);
}

func ws_dynamic_array_to_calldata2_write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(
   loc : felt,
   index : felt,
   len : felt,
   ptr : felt*) -> (ptr : felt*){
   alloc_locals;
   if (len == index){
       return (ptr,);
   }
   let (index_uint256) = warp_uint256(index);
   let (elem_loc) = WARP_DARRAY1_felt.read(loc, index_uint256);
   let (elem) = WS1_READ_felt(elem_loc);
   assert ptr[index] = elem;
   return ws_dynamic_array_to_calldata2_write(loc, index + 1, len, ptr);
}
func ws_dynamic_array_to_calldata2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt) -> (dyn_array_struct : cd_dynarray_felt){
   alloc_locals;
   let (len_uint256) = WARP_DARRAY1_felt_LENGTH.read(loc);
   let len = len_uint256.low + len_uint256.high*128;
   let (ptr : felt*) = alloc();
   let (ptr : felt*) = ws_dynamic_array_to_calldata2_write(loc, 0, len, ptr);
   let dyn_array_struct = cd_dynarray_felt(len, ptr);
   return (dyn_array_struct,);
}

func ws_dynamic_array_to_calldata3_write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(
   loc : felt,
   index : felt,
   len : felt,
   ptr : felt*) -> (ptr : felt*){
   alloc_locals;
   if (len == index){
       return (ptr,);
   }
   let (index_uint256) = warp_uint256(index);
   let (elem_loc) = WARP_DARRAY1_felt.read(loc, index_uint256);
   let (elem) = WS1_READ_felt(elem_loc);
   assert ptr[index] = elem;
   return ws_dynamic_array_to_calldata3_write(loc, index + 1, len, ptr);
}
func ws_dynamic_array_to_calldata3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt) -> (dyn_array_struct : cd_dynarray_felt){
   alloc_locals;
   let (len_uint256) = WARP_DARRAY1_felt_LENGTH.read(loc);
   let len = len_uint256.low + len_uint256.high*128;
   let (ptr : felt*) = alloc();
   let (ptr : felt*) = ws_dynamic_array_to_calldata3_write(loc, 0, len, ptr);
   let dyn_array_struct = cd_dynarray_felt(len, ptr);
   return (dyn_array_struct,);
}

func WS_WRITE0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: felt) -> (res: felt){
    WARP_STORAGE.write(loc, value);
    return (value,);
}

func WS_WRITE1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: Uint256) -> (res: Uint256){
    WARP_STORAGE.write(loc, value.low);
    WARP_STORAGE.write(loc + 1, value.high);
    return (value,);
}

func extern_input_check0{range_check_ptr : felt}(len: felt, ptr : Uint256*) -> (){
    alloc_locals;
    if (len == 0){
        return ();
    }
warp_external_input_check_int256(ptr[0]);
   extern_input_check0(len = len - 1, ptr = ptr + 2);
    return ();
}

func extern_input_check1{range_check_ptr : felt}(len: felt, ptr : Uint256*) -> (){
    alloc_locals;
    if (len == 0){
        return ();
    }
warp_external_input_check_int256(ptr[0]);
   extern_input_check1(len = len - 1, ptr = ptr + 2);
    return ();
}

func extern_input_check2{range_check_ptr : felt}(len: felt, ptr : felt*) -> (){
    alloc_locals;
    if (len == 0){
        return ();
    }
warp_external_input_check_int8(ptr[0]);
   extern_input_check2(len = len - 1, ptr = ptr + 1);
    return ();
}

func extern_input_check3{range_check_ptr : felt}(len: felt, ptr : felt*) -> (){
    alloc_locals;
    if (len == 0){
        return ();
    }
warp_external_input_check_address(ptr[0]);
   extern_input_check3(len = len - 1, ptr = ptr + 1);
    return ();
}

func cd_dynamic_array_to_storage0_write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt, index : felt, len : felt, elem: Uint256*){
   alloc_locals;
   if (index == len){
       return ();
   }
   let (index_uint256) = warp_uint256(index);
   let (elem_loc) = WARP_DARRAY0_Uint256.read(loc, index_uint256);
   if (elem_loc == 0){
       let (elem_loc) = WARP_USED_STORAGE.read();
       WARP_USED_STORAGE.write(elem_loc + 2);
       WARP_DARRAY0_Uint256.write(loc, index_uint256, elem_loc);
       WS_WRITE1(elem_loc, elem[index]);
       return cd_dynamic_array_to_storage0_write(loc, index + 1, len, elem);
   }else{
       WS_WRITE1(elem_loc, elem[index]);
       return cd_dynamic_array_to_storage0_write(loc, index + 1, len, elem);
   }
}
func cd_dynamic_array_to_storage0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt, dyn_array_struct : cd_dynarray_Uint256) -> (loc : felt){ 
   alloc_locals;
   let (len_uint256) = warp_uint256(dyn_array_struct.len);
   WARP_DARRAY0_Uint256_LENGTH.write(loc, len_uint256);
   cd_dynamic_array_to_storage0_write(loc, 0, dyn_array_struct.len, dyn_array_struct.ptr);
   return (loc,);
}

func cd_dynamic_array_to_storage1_write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt, index : felt, len : felt, elem: Uint256*){
   alloc_locals;
   if (index == len){
       return ();
   }
   let (index_uint256) = warp_uint256(index);
   let (elem_loc) = WARP_DARRAY0_Uint256.read(loc, index_uint256);
   if (elem_loc == 0){
       let (elem_loc) = WARP_USED_STORAGE.read();
       WARP_USED_STORAGE.write(elem_loc + 2);
       WARP_DARRAY0_Uint256.write(loc, index_uint256, elem_loc);
       WS_WRITE1(elem_loc, elem[index]);
       return cd_dynamic_array_to_storage1_write(loc, index + 1, len, elem);
   }else{
       WS_WRITE1(elem_loc, elem[index]);
       return cd_dynamic_array_to_storage1_write(loc, index + 1, len, elem);
   }
}
func cd_dynamic_array_to_storage1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt, dyn_array_struct : cd_dynarray_Uint256) -> (loc : felt){ 
   alloc_locals;
   let (len_uint256) = warp_uint256(dyn_array_struct.len);
   WARP_DARRAY0_Uint256_LENGTH.write(loc, len_uint256);
   cd_dynamic_array_to_storage1_write(loc, 0, dyn_array_struct.len, dyn_array_struct.ptr);
   return (loc,);
}

func cd_dynamic_array_to_storage2_write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt, index : felt, len : felt, elem: felt*){
   alloc_locals;
   if (index == len){
       return ();
   }
   let (index_uint256) = warp_uint256(index);
   let (elem_loc) = WARP_DARRAY1_felt.read(loc, index_uint256);
   if (elem_loc == 0){
       let (elem_loc) = WARP_USED_STORAGE.read();
       WARP_USED_STORAGE.write(elem_loc + 1);
       WARP_DARRAY1_felt.write(loc, index_uint256, elem_loc);
       WS_WRITE0(elem_loc, elem[index]);
       return cd_dynamic_array_to_storage2_write(loc, index + 1, len, elem);
   }else{
       WS_WRITE0(elem_loc, elem[index]);
       return cd_dynamic_array_to_storage2_write(loc, index + 1, len, elem);
   }
}
func cd_dynamic_array_to_storage2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt, dyn_array_struct : cd_dynarray_felt) -> (loc : felt){ 
   alloc_locals;
   let (len_uint256) = warp_uint256(dyn_array_struct.len);
   WARP_DARRAY1_felt_LENGTH.write(loc, len_uint256);
   cd_dynamic_array_to_storage2_write(loc, 0, dyn_array_struct.len, dyn_array_struct.ptr);
   return (loc,);
}

func cd_dynamic_array_to_storage3_write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt, index : felt, len : felt, elem: felt*){
   alloc_locals;
   if (index == len){
       return ();
   }
   let (index_uint256) = warp_uint256(index);
   let (elem_loc) = WARP_DARRAY1_felt.read(loc, index_uint256);
   if (elem_loc == 0){
       let (elem_loc) = WARP_USED_STORAGE.read();
       WARP_USED_STORAGE.write(elem_loc + 1);
       WARP_DARRAY1_felt.write(loc, index_uint256, elem_loc);
       WS_WRITE0(elem_loc, elem[index]);
       return cd_dynamic_array_to_storage3_write(loc, index + 1, len, elem);
   }else{
       WS_WRITE0(elem_loc, elem[index]);
       return cd_dynamic_array_to_storage3_write(loc, index + 1, len, elem);
   }
}
func cd_dynamic_array_to_storage3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt, dyn_array_struct : cd_dynarray_felt) -> (loc : felt){ 
   alloc_locals;
   let (len_uint256) = warp_uint256(dyn_array_struct.len);
   WARP_DARRAY1_felt_LENGTH.write(loc, len_uint256);
   cd_dynamic_array_to_storage3_write(loc, 0, dyn_array_struct.len, dyn_array_struct.ptr);
   return (loc,);
}

@storage_var
func WARP_DARRAY0_Uint256(name: felt, index: Uint256) -> (resLoc : felt){
}
@storage_var
func WARP_DARRAY0_Uint256_LENGTH(name: felt) -> (index: Uint256){
}

@storage_var
func WARP_DARRAY1_felt(name: felt, index: Uint256) -> (resLoc : felt){
}
@storage_var
func WARP_DARRAY1_felt_LENGTH(name: felt) -> (index: Uint256){
}

@storage_var
func WARP_MAPPING0(name: felt, index: felt) -> (resLoc : felt){
}
func WS0_INDEX_felt_to_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING0.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_MAPPING0.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING1(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS1_INDEX_Uint256_to_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING1.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_MAPPING1.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING2(name: felt, index: felt) -> (resLoc : felt){
}
func WS2_INDEX_felt_to_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING2.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_MAPPING2.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING3(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS3_INDEX_Uint256_to_warp_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING3.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_MAPPING3.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING4(name: felt, index: felt) -> (resLoc : felt){
}
func WS4_INDEX_felt_to_warp_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING4.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_MAPPING4.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING5(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS5_INDEX_Uint256_to_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING5.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_MAPPING5.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING6(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS6_INDEX_Uint256_to_FacetAddressAndPosition_80522e2c{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING6.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_MAPPING6.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING7(name: felt, index: felt) -> (resLoc : felt){
}
func WS7_INDEX_felt_to_FacetFunctionSelectors_ba2cb0c5{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING7.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 3);
        WARP_MAPPING7.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}


// Contract Def AppStorage


namespace AppStorage{

    // Dynamic variables - Arrays and Maps

    const __warp_2_allowedFacet = 1;

    // Static variables

    const __warp_0_appStorage = 0;

    const __warp_1_storageOwner = 29;


    func __warp_constructor_0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_3__owner : felt)-> (){
    alloc_locals;


        
        WS_WRITE0(__warp_1_storageOwner, __warp_3__owner);
        
        
        
        return ();

    }

}


    @external
    func addNewAllowedFacet_a8493237{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_4__facet : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_address(__warp_4__facet);
        
        let (__warp_se_0) = get_caller_address();
        
        let (__warp_se_1) = WS1_READ_felt(AppStorage.__warp_1_storageOwner);
        
        let (__warp_se_2) = warp_eq(__warp_se_0, __warp_se_1);
        
        with_attr error_message("not the storage owner"){
            assert __warp_se_2 = 1;
        }
        
        let (__warp_se_3) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_4__facet);
        
        WS_WRITE0(__warp_se_3, 1);
        
        
        
        return ();

    }


    @view
    func treasury_61d027b3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_5 : Uint256){
    alloc_locals;


        
        let (__warp_se_4) = WSM0_Storage_14a18fd6_treasury(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_5) = WS2_READ_Uint256(__warp_se_4);
        
        
        
        return (__warp_se_5,);

    }


    @external
    func setTreasury_7139c929{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_6__newTreasury : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_6__newTreasury);
        
        let (__warp_se_6) = get_caller_address();
        
        let (__warp_se_7) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_6);
        
        let (__warp_se_8) = WS1_READ_felt(__warp_se_7);
        
        let (__warp_se_9) = warp_eq(__warp_se_8, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_9 = 1;
        }
        
        let (__warp_se_10) = WSM0_Storage_14a18fd6_treasury(AppStorage.__warp_0_appStorage);
        
        WS_WRITE1(__warp_se_10, __warp_6__newTreasury);
        
        
        
        return ();

    }


    @view
    func budget_ed01bf29{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_7 : Uint256){
    alloc_locals;


        
        let (__warp_se_11) = WSM1_Storage_14a18fd6_budget(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_12) = WS2_READ_Uint256(__warp_se_11);
        
        
        
        return (__warp_se_12,);

    }


    @external
    func setBudget_bc8523fc{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_8__newBudget : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_8__newBudget);
        
        let (__warp_se_13) = get_caller_address();
        
        let (__warp_se_14) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_13);
        
        let (__warp_se_15) = WS1_READ_felt(__warp_se_14);
        
        let (__warp_se_16) = warp_eq(__warp_se_15, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_16 = 1;
        }
        
        let (__warp_se_17) = WSM1_Storage_14a18fd6_budget(AppStorage.__warp_0_appStorage);
        
        WS_WRITE1(__warp_se_17, __warp_8__newBudget);
        
        
        
        return ();

    }


    @view
    func period_ef78d4fd{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_9 : Uint256){
    alloc_locals;


        
        let (__warp_se_18) = WSM2_Storage_14a18fd6_period(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_19) = WS2_READ_Uint256(__warp_se_18);
        
        
        
        return (__warp_se_19,);

    }


    @external
    func setPeriod_0f3a9f65{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_10__newPeriod : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_10__newPeriod);
        
        let (__warp_se_20) = get_caller_address();
        
        let (__warp_se_21) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_20);
        
        let (__warp_se_22) = WS1_READ_felt(__warp_se_21);
        
        let (__warp_se_23) = warp_eq(__warp_se_22, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_23 = 1;
        }
        
        let (__warp_se_24) = WSM2_Storage_14a18fd6_period(AppStorage.__warp_0_appStorage);
        
        WS_WRITE1(__warp_se_24, __warp_10__newPeriod);
        
        
        
        return ();

    }


    @view
    func governanceToken_f96dae0a{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_11 : felt){
    alloc_locals;


        
        let (__warp_se_25) = WSM3_Storage_14a18fd6_governanceToken(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_26) = WS1_READ_felt(__warp_se_25);
        
        
        
        return (__warp_se_26,);

    }


    @external
    func setGovernanceToken_f8570170{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_12__newGovernanceToken : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_address(__warp_12__newGovernanceToken);
        
        let (__warp_se_27) = get_caller_address();
        
        let (__warp_se_28) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_27);
        
        let (__warp_se_29) = WS1_READ_felt(__warp_se_28);
        
        let (__warp_se_30) = warp_eq(__warp_se_29, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_30 = 1;
        }
        
        let (__warp_se_31) = WSM3_Storage_14a18fd6_governanceToken(AppStorage.__warp_0_appStorage);
        
        WS_WRITE0(__warp_se_31, __warp_12__newGovernanceToken);
        
        
        
        return ();

    }


    @view
    func governor_0c340a24{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_13 : felt){
    alloc_locals;


        
        let (__warp_se_32) = WSM4_Storage_14a18fd6_governor(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_33) = WS1_READ_felt(__warp_se_32);
        
        
        
        return (__warp_se_33,);

    }


    @external
    func setGovernor_c42cf535{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_14__newGovernor : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_address(__warp_14__newGovernor);
        
        let (__warp_se_34) = get_caller_address();
        
        let (__warp_se_35) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_34);
        
        let (__warp_se_36) = WS1_READ_felt(__warp_se_35);
        
        let (__warp_se_37) = warp_eq(__warp_se_36, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_37 = 1;
        }
        
        let (__warp_se_38) = WSM4_Storage_14a18fd6_governor(AppStorage.__warp_0_appStorage);
        
        WS_WRITE0(__warp_se_38, __warp_14__newGovernor);
        
        
        
        return ();

    }


    @view
    func availableRights_1faf10c5{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_15_len : felt, __warp_15 : Uint256*){
    alloc_locals;


        
        let (__warp_se_39) = WSM5_Storage_14a18fd6_availableRights(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_40) = WS0_READ_warp_id(__warp_se_39);
        
        let (__warp_se_41) = ws_dynamic_array_to_calldata0(__warp_se_40);
        
        
        
        return (__warp_se_41.len, __warp_se_41.ptr,);

    }


    @external
    func setAvailableRights_aec0f150{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_16__newAvailableRights_len : felt, __warp_16__newAvailableRights : Uint256*)-> (){
    alloc_locals;


        
        extern_input_check0(__warp_16__newAvailableRights_len, __warp_16__newAvailableRights);
        
        local __warp_16__newAvailableRights_dstruct : cd_dynarray_Uint256 = cd_dynarray_Uint256(__warp_16__newAvailableRights_len, __warp_16__newAvailableRights);
        
        let (__warp_se_42) = get_caller_address();
        
        let (__warp_se_43) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_42);
        
        let (__warp_se_44) = WS1_READ_felt(__warp_se_43);
        
        let (__warp_se_45) = warp_eq(__warp_se_44, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_45 = 1;
        }
        
        let (__warp_se_46) = WSM5_Storage_14a18fd6_availableRights(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_47) = WS0_READ_warp_id(__warp_se_46);
        
        cd_dynamic_array_to_storage0(__warp_se_47, __warp_16__newAvailableRights_dstruct);
        
        
        
        return ();

    }


    @view
    func highestDeadline_68f4a3c9{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_17__id : Uint256)-> (__warp_18 : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_17__id);
        
        let (__warp_se_48) = WSM6_Storage_14a18fd6_highestDeadline(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_49) = WS0_READ_warp_id(__warp_se_48);
        
        let (__warp_se_50) = WS1_INDEX_Uint256_to_Uint256(__warp_se_49, __warp_17__id);
        
        let (__warp_se_51) = WS2_READ_Uint256(__warp_se_50);
        
        
        
        return (__warp_se_51,);

    }


    @external
    func setHighestDeadline_30e8ce9d{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_19__id : Uint256, __warp_20__newDeadline : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_20__newDeadline);
        
        warp_external_input_check_int256(__warp_19__id);
        
        let (__warp_se_52) = get_caller_address();
        
        let (__warp_se_53) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_52);
        
        let (__warp_se_54) = WS1_READ_felt(__warp_se_53);
        
        let (__warp_se_55) = warp_eq(__warp_se_54, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_55 = 1;
        }
        
        let (__warp_se_56) = WSM6_Storage_14a18fd6_highestDeadline(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_57) = WS0_READ_warp_id(__warp_se_56);
        
        let (__warp_se_58) = WS1_INDEX_Uint256_to_Uint256(__warp_se_57, __warp_19__id);
        
        WS_WRITE1(__warp_se_58, __warp_20__newDeadline);
        
        
        
        return ();

    }


    @view
    func dividends_68306e43{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_21__user : felt)-> (__warp_22 : Uint256){
    alloc_locals;


        
        warp_external_input_check_address(__warp_21__user);
        
        let (__warp_se_59) = WSM7_Storage_14a18fd6_dividends(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_60) = WS0_READ_warp_id(__warp_se_59);
        
        let (__warp_se_61) = WS2_INDEX_felt_to_Uint256(__warp_se_60, __warp_21__user);
        
        let (__warp_se_62) = WS2_READ_Uint256(__warp_se_61);
        
        
        
        return (__warp_se_62,);

    }


    @external
    func setDividends_949183c6{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_23__user : felt, __warp_24__newDividend : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_24__newDividend);
        
        warp_external_input_check_address(__warp_23__user);
        
        let (__warp_se_63) = get_caller_address();
        
        let (__warp_se_64) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_63);
        
        let (__warp_se_65) = WS1_READ_felt(__warp_se_64);
        
        let (__warp_se_66) = warp_eq(__warp_se_65, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_66 = 1;
        }
        
        let (__warp_se_67) = WSM7_Storage_14a18fd6_dividends(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_68) = WS0_READ_warp_id(__warp_se_67);
        
        let (__warp_se_69) = WS2_INDEX_felt_to_Uint256(__warp_se_68, __warp_23__user);
        
        WS_WRITE1(__warp_se_69, __warp_24__newDividend);
        
        
        
        return ();

    }


    @view
    func rightsOrigin_3e88bf60{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_25__id : Uint256)-> (__warp_26_len : felt, __warp_26 : Uint256*){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_25__id);
        
        let (__warp_se_70) = WSM8_Storage_14a18fd6_rightsOrigin(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_71) = WS0_READ_warp_id(__warp_se_70);
        
        let (__warp_se_72) = WS3_INDEX_Uint256_to_warp_id(__warp_se_71, __warp_25__id);
        
        let (__warp_se_73) = WS0_READ_warp_id(__warp_se_72);
        
        let (__warp_se_74) = ws_dynamic_array_to_calldata1(__warp_se_73);
        
        
        
        return (__warp_se_74.len, __warp_se_74.ptr,);

    }


    @external
    func setRightsOrigin_4e072a06{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_27__id : Uint256, __warp_28__newOrigin_len : felt, __warp_28__newOrigin : Uint256*)-> (){
    alloc_locals;


        
        extern_input_check1(__warp_28__newOrigin_len, __warp_28__newOrigin);
        
        warp_external_input_check_int256(__warp_27__id);
        
        local __warp_28__newOrigin_dstruct : cd_dynarray_Uint256 = cd_dynarray_Uint256(__warp_28__newOrigin_len, __warp_28__newOrigin);
        
        let (__warp_se_75) = get_caller_address();
        
        let (__warp_se_76) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_75);
        
        let (__warp_se_77) = WS1_READ_felt(__warp_se_76);
        
        let (__warp_se_78) = warp_eq(__warp_se_77, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_78 = 1;
        }
        
        let (__warp_se_79) = WSM8_Storage_14a18fd6_rightsOrigin(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_80) = WS0_READ_warp_id(__warp_se_79);
        
        let (__warp_se_81) = WS3_INDEX_Uint256_to_warp_id(__warp_se_80, __warp_27__id);
        
        let (__warp_se_82) = WS0_READ_warp_id(__warp_se_81);
        
        cd_dynamic_array_to_storage1(__warp_se_82, __warp_28__newOrigin_dstruct);
        
        
        
        return ();

    }


    @view
    func rightUri_eca2e6dd{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_29__id : Uint256)-> (__warp_30_len : felt, __warp_30 : felt*){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_29__id);
        
        let (__warp_se_83) = WSM9_Storage_14a18fd6_rightUri(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_84) = WS0_READ_warp_id(__warp_se_83);
        
        let (__warp_se_85) = WS3_INDEX_Uint256_to_warp_id(__warp_se_84, __warp_29__id);
        
        let (__warp_se_86) = WS0_READ_warp_id(__warp_se_85);
        
        let (__warp_se_87) = ws_dynamic_array_to_calldata2(__warp_se_86);
        
        
        
        return (__warp_se_87.len, __warp_se_87.ptr,);

    }


    @external
    func setRightUri_8f15dc87{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_31__id : Uint256, __warp_32__newUri_len : felt, __warp_32__newUri : felt*)-> (){
    alloc_locals;


        
        extern_input_check2(__warp_32__newUri_len, __warp_32__newUri);
        
        warp_external_input_check_int256(__warp_31__id);
        
        local __warp_32__newUri_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_32__newUri_len, __warp_32__newUri);
        
        let (__warp_se_88) = get_caller_address();
        
        let (__warp_se_89) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_88);
        
        let (__warp_se_90) = WS1_READ_felt(__warp_se_89);
        
        let (__warp_se_91) = warp_eq(__warp_se_90, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_91 = 1;
        }
        
        let (__warp_se_92) = WSM9_Storage_14a18fd6_rightUri(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_93) = WS0_READ_warp_id(__warp_se_92);
        
        let (__warp_se_94) = WS3_INDEX_Uint256_to_warp_id(__warp_se_93, __warp_31__id);
        
        let (__warp_se_95) = WS0_READ_warp_id(__warp_se_94);
        
        cd_dynamic_array_to_storage2(__warp_se_95, __warp_32__newUri_dstruct);
        
        
        
        return ();

    }


    @view
    func dailyPrice_141b684a{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_33__id : Uint256)-> (__warp_34 : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_33__id);
        
        let (__warp_se_96) = WSM10_Storage_14a18fd6_dailyPrice(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_97) = WS0_READ_warp_id(__warp_se_96);
        
        let (__warp_se_98) = WS1_INDEX_Uint256_to_Uint256(__warp_se_97, __warp_33__id);
        
        let (__warp_se_99) = WS2_READ_Uint256(__warp_se_98);
        
        
        
        return (__warp_se_99,);

    }


    @external
    func setDailyPrice_90709a21{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_35__id : Uint256, __warp_36__newDailyPrice : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_36__newDailyPrice);
        
        warp_external_input_check_int256(__warp_35__id);
        
        let (__warp_se_100) = get_caller_address();
        
        let (__warp_se_101) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_100);
        
        let (__warp_se_102) = WS1_READ_felt(__warp_se_101);
        
        let (__warp_se_103) = warp_eq(__warp_se_102, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_103 = 1;
        }
        
        let (__warp_se_104) = WSM10_Storage_14a18fd6_dailyPrice(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_105) = WS0_READ_warp_id(__warp_se_104);
        
        let (__warp_se_106) = WS1_INDEX_Uint256_to_Uint256(__warp_se_105, __warp_35__id);
        
        WS_WRITE1(__warp_se_106, __warp_36__newDailyPrice);
        
        
        
        return ();

    }


    @view
    func maxRightsHolders_e0975909{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_37__id : Uint256)-> (__warp_38 : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_37__id);
        
        let (__warp_se_107) = WSM11_Storage_14a18fd6_maxRightsHolders(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_108) = WS0_READ_warp_id(__warp_se_107);
        
        let (__warp_se_109) = WS1_INDEX_Uint256_to_Uint256(__warp_se_108, __warp_37__id);
        
        let (__warp_se_110) = WS2_READ_Uint256(__warp_se_109);
        
        
        
        return (__warp_se_110,);

    }


    @external
    func setMaxRightsHolders_ea651dc8{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_39__id : Uint256, __warp_40__newMaxHolders : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_40__newMaxHolders);
        
        warp_external_input_check_int256(__warp_39__id);
        
        let (__warp_se_111) = get_caller_address();
        
        let (__warp_se_112) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_111);
        
        let (__warp_se_113) = WS1_READ_felt(__warp_se_112);
        
        let (__warp_se_114) = warp_eq(__warp_se_113, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_114 = 1;
        }
        
        let (__warp_se_115) = WSM11_Storage_14a18fd6_maxRightsHolders(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_116) = WS0_READ_warp_id(__warp_se_115);
        
        let (__warp_se_117) = WS1_INDEX_Uint256_to_Uint256(__warp_se_116, __warp_39__id);
        
        WS_WRITE1(__warp_se_117, __warp_40__newMaxHolders);
        
        
        
        return ();

    }


    @view
    func maxtime_b9b6a337{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_41__id : Uint256)-> (__warp_42 : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_41__id);
        
        let (__warp_se_118) = WSM12_Storage_14a18fd6_maxtime(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_119) = WS0_READ_warp_id(__warp_se_118);
        
        let (__warp_se_120) = WS1_INDEX_Uint256_to_Uint256(__warp_se_119, __warp_41__id);
        
        let (__warp_se_121) = WS2_READ_Uint256(__warp_se_120);
        
        
        
        return (__warp_se_121,);

    }


    @external
    func setMaxtime_3a5024bd{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_43__id : Uint256, __warp_44__newMaxTime : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_44__newMaxTime);
        
        warp_external_input_check_int256(__warp_43__id);
        
        let (__warp_se_122) = get_caller_address();
        
        let (__warp_se_123) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_122);
        
        let (__warp_se_124) = WS1_READ_felt(__warp_se_123);
        
        let (__warp_se_125) = warp_eq(__warp_se_124, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_125 = 1;
        }
        
        let (__warp_se_126) = WSM12_Storage_14a18fd6_maxtime(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_127) = WS0_READ_warp_id(__warp_se_126);
        
        let (__warp_se_128) = WS1_INDEX_Uint256_to_Uint256(__warp_se_127, __warp_43__id);
        
        WS_WRITE1(__warp_se_128, __warp_44__newMaxTime);
        
        
        
        return ();

    }


    @view
    func rightsOver_47937af1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_45__user : felt)-> (__warp_46_len : felt, __warp_46 : Uint256*){
    alloc_locals;


        
        warp_external_input_check_address(__warp_45__user);
        
        let (__warp_se_129) = WSM13_Storage_14a18fd6_rightsOver(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_130) = WS0_READ_warp_id(__warp_se_129);
        
        let (__warp_se_131) = WS4_INDEX_felt_to_warp_id(__warp_se_130, __warp_45__user);
        
        let (__warp_se_132) = WS0_READ_warp_id(__warp_se_131);
        
        let (__warp_se_133) = ws_dynamic_array_to_calldata0(__warp_se_132);
        
        
        
        return (__warp_se_133.len, __warp_se_133.ptr,);

    }


    @external
    func setRightsOver_8283fd9c{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_47__user : felt, __warp_48__newRights_len : felt, __warp_48__newRights : Uint256*)-> (){
    alloc_locals;


        
        extern_input_check0(__warp_48__newRights_len, __warp_48__newRights);
        
        warp_external_input_check_address(__warp_47__user);
        
        local __warp_48__newRights_dstruct : cd_dynarray_Uint256 = cd_dynarray_Uint256(__warp_48__newRights_len, __warp_48__newRights);
        
        let (__warp_se_134) = get_caller_address();
        
        let (__warp_se_135) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_134);
        
        let (__warp_se_136) = WS1_READ_felt(__warp_se_135);
        
        let (__warp_se_137) = warp_eq(__warp_se_136, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_137 = 1;
        }
        
        let (__warp_se_138) = WSM13_Storage_14a18fd6_rightsOver(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_139) = WS0_READ_warp_id(__warp_se_138);
        
        let (__warp_se_140) = WS4_INDEX_felt_to_warp_id(__warp_se_139, __warp_47__user);
        
        let (__warp_se_141) = WS0_READ_warp_id(__warp_se_140);
        
        cd_dynamic_array_to_storage0(__warp_se_141, __warp_48__newRights_dstruct);
        
        
        
        return ();

    }


    @view
    func properties_25ec77d7{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_49__user : felt)-> (__warp_50_len : felt, __warp_50 : Uint256*){
    alloc_locals;


        
        warp_external_input_check_address(__warp_49__user);
        
        let (__warp_se_142) = WSM14_Storage_14a18fd6_properties(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_143) = WS0_READ_warp_id(__warp_se_142);
        
        let (__warp_se_144) = WS4_INDEX_felt_to_warp_id(__warp_se_143, __warp_49__user);
        
        let (__warp_se_145) = WS0_READ_warp_id(__warp_se_144);
        
        let (__warp_se_146) = ws_dynamic_array_to_calldata0(__warp_se_145);
        
        
        
        return (__warp_se_146.len, __warp_se_146.ptr,);

    }


    @external
    func setProperties_791d847f{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_51__user : felt, __warp_52__newProperties_len : felt, __warp_52__newProperties : Uint256*)-> (){
    alloc_locals;


        
        extern_input_check0(__warp_52__newProperties_len, __warp_52__newProperties);
        
        warp_external_input_check_address(__warp_51__user);
        
        local __warp_52__newProperties_dstruct : cd_dynarray_Uint256 = cd_dynarray_Uint256(__warp_52__newProperties_len, __warp_52__newProperties);
        
        let (__warp_se_147) = get_caller_address();
        
        let (__warp_se_148) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_147);
        
        let (__warp_se_149) = WS1_READ_felt(__warp_se_148);
        
        let (__warp_se_150) = warp_eq(__warp_se_149, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_150 = 1;
        }
        
        let (__warp_se_151) = WSM14_Storage_14a18fd6_properties(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_152) = WS0_READ_warp_id(__warp_se_151);
        
        let (__warp_se_153) = WS4_INDEX_felt_to_warp_id(__warp_se_152, __warp_51__user);
        
        let (__warp_se_154) = WS0_READ_warp_id(__warp_se_153);
        
        cd_dynamic_array_to_storage0(__warp_se_154, __warp_52__newProperties_dstruct);
        
        
        
        return ();

    }


    @view
    func isAvailable_3a178d99{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_53__id : Uint256)-> (__warp_54 : felt){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_53__id);
        
        let (__warp_se_155) = WSM15_Storage_14a18fd6_isAvailable(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_156) = WS0_READ_warp_id(__warp_se_155);
        
        let (__warp_se_157) = WS5_INDEX_Uint256_to_felt(__warp_se_156, __warp_53__id);
        
        let (__warp_se_158) = WS1_READ_felt(__warp_se_157);
        
        
        
        return (__warp_se_158,);

    }


    @external
    func setIsAvailable_7f89a5c5{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_55__id : Uint256, __warp_56__newAvailabilitie : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_bool(__warp_56__newAvailabilitie);
        
        warp_external_input_check_int256(__warp_55__id);
        
        let (__warp_se_159) = get_caller_address();
        
        let (__warp_se_160) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_159);
        
        let (__warp_se_161) = WS1_READ_felt(__warp_se_160);
        
        let (__warp_se_162) = warp_eq(__warp_se_161, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_162 = 1;
        }
        
        let (__warp_se_163) = WSM15_Storage_14a18fd6_isAvailable(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_164) = WS0_READ_warp_id(__warp_se_163);
        
        let (__warp_se_165) = WS5_INDEX_Uint256_to_felt(__warp_se_164, __warp_55__id);
        
        WS_WRITE0(__warp_se_165, __warp_56__newAvailabilitie);
        
        
        
        return ();

    }


    @view
    func owner_a123c33e{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_57__id : Uint256)-> (__warp_58 : felt){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_57__id);
        
        let (__warp_se_166) = WSM16_Storage_14a18fd6_owner(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_167) = WS0_READ_warp_id(__warp_se_166);
        
        let (__warp_se_168) = WS5_INDEX_Uint256_to_felt(__warp_se_167, __warp_57__id);
        
        let (__warp_se_169) = WS1_READ_felt(__warp_se_168);
        
        
        
        return (__warp_se_169,);

    }


    @external
    func setOwner_7fd39247{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_59__id : Uint256, __warp_60__newRightOwner : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_address(__warp_60__newRightOwner);
        
        warp_external_input_check_int256(__warp_59__id);
        
        let (__warp_se_170) = get_caller_address();
        
        let (__warp_se_171) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_170);
        
        let (__warp_se_172) = WS1_READ_felt(__warp_se_171);
        
        let (__warp_se_173) = warp_eq(__warp_se_172, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_173 = 1;
        }
        
        let (__warp_se_174) = WSM16_Storage_14a18fd6_owner(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_175) = WS0_READ_warp_id(__warp_se_174);
        
        let (__warp_se_176) = WS5_INDEX_Uint256_to_felt(__warp_se_175, __warp_59__id);
        
        WS_WRITE0(__warp_se_176, __warp_60__newRightOwner);
        
        
        
        return ();

    }


    @view
    func rightHolders_5d0fab84{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_61__id : Uint256)-> (__warp_62_len : felt, __warp_62 : felt*){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_61__id);
        
        let (__warp_se_177) = WSM17_Storage_14a18fd6_rightHolders(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_178) = WS0_READ_warp_id(__warp_se_177);
        
        let (__warp_se_179) = WS3_INDEX_Uint256_to_warp_id(__warp_se_178, __warp_61__id);
        
        let (__warp_se_180) = WS0_READ_warp_id(__warp_se_179);
        
        let (__warp_se_181) = ws_dynamic_array_to_calldata3(__warp_se_180);
        
        
        
        return (__warp_se_181.len, __warp_se_181.ptr,);

    }


    @external
    func setRightHolders_19dde9b2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_63__id : Uint256, __warp_64__newRightHolders_len : felt, __warp_64__newRightHolders : felt*)-> (){
    alloc_locals;


        
        extern_input_check3(__warp_64__newRightHolders_len, __warp_64__newRightHolders);
        
        warp_external_input_check_int256(__warp_63__id);
        
        local __warp_64__newRightHolders_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_64__newRightHolders_len, __warp_64__newRightHolders);
        
        let (__warp_se_182) = get_caller_address();
        
        let (__warp_se_183) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_182);
        
        let (__warp_se_184) = WS1_READ_felt(__warp_se_183);
        
        let (__warp_se_185) = warp_eq(__warp_se_184, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_185 = 1;
        }
        
        let (__warp_se_186) = WSM17_Storage_14a18fd6_rightHolders(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_187) = WS0_READ_warp_id(__warp_se_186);
        
        let (__warp_se_188) = WS3_INDEX_Uint256_to_warp_id(__warp_se_187, __warp_63__id);
        
        let (__warp_se_189) = WS0_READ_warp_id(__warp_se_188);
        
        cd_dynamic_array_to_storage3(__warp_se_189, __warp_64__newRightHolders_dstruct);
        
        
        
        return ();

    }


    @view
    func deadline_10c2e3cd{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_65__id : Uint256, __warp_66__user : felt)-> (__warp_67 : Uint256){
    alloc_locals;


        
        warp_external_input_check_address(__warp_66__user);
        
        warp_external_input_check_int256(__warp_65__id);
        
        let (__warp_se_190) = WSM18_Storage_14a18fd6_deadline(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_191) = WS0_READ_warp_id(__warp_se_190);
        
        let (__warp_se_192) = WS3_INDEX_Uint256_to_warp_id(__warp_se_191, __warp_65__id);
        
        let (__warp_se_193) = WS0_READ_warp_id(__warp_se_192);
        
        let (__warp_se_194) = WS2_INDEX_felt_to_Uint256(__warp_se_193, __warp_66__user);
        
        let (__warp_se_195) = WS2_READ_Uint256(__warp_se_194);
        
        
        
        return (__warp_se_195,);

    }


    @external
    func setDeadline_1bd2edb6{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_68__id : Uint256, __warp_69__user : felt, __warp_70__newDeadline : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_70__newDeadline);
        
        warp_external_input_check_address(__warp_69__user);
        
        warp_external_input_check_int256(__warp_68__id);
        
        let (__warp_se_196) = get_caller_address();
        
        let (__warp_se_197) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_196);
        
        let (__warp_se_198) = WS1_READ_felt(__warp_se_197);
        
        let (__warp_se_199) = warp_eq(__warp_se_198, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_199 = 1;
        }
        
        let (__warp_se_200) = WSM18_Storage_14a18fd6_deadline(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_201) = WS0_READ_warp_id(__warp_se_200);
        
        let (__warp_se_202) = WS3_INDEX_Uint256_to_warp_id(__warp_se_201, __warp_68__id);
        
        let (__warp_se_203) = WS0_READ_warp_id(__warp_se_202);
        
        let (__warp_se_204) = WS2_INDEX_felt_to_Uint256(__warp_se_203, __warp_69__user);
        
        WS_WRITE1(__warp_se_204, __warp_70__newDeadline);
        
        
        
        return ();

    }


    @view
    func rightsPeriod_f6ddac46{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_71__id : Uint256, __warp_72__user : felt)-> (__warp_73 : Uint256){
    alloc_locals;


        
        warp_external_input_check_address(__warp_72__user);
        
        warp_external_input_check_int256(__warp_71__id);
        
        let (__warp_se_205) = WSM19_Storage_14a18fd6_rightsPeriod(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_206) = WS0_READ_warp_id(__warp_se_205);
        
        let (__warp_se_207) = WS3_INDEX_Uint256_to_warp_id(__warp_se_206, __warp_71__id);
        
        let (__warp_se_208) = WS0_READ_warp_id(__warp_se_207);
        
        let (__warp_se_209) = WS2_INDEX_felt_to_Uint256(__warp_se_208, __warp_72__user);
        
        let (__warp_se_210) = WS2_READ_Uint256(__warp_se_209);
        
        
        
        return (__warp_se_210,);

    }


    @external
    func setRightsPeriod_4edd3038{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_74__id : Uint256, __warp_75__user : felt, __warp_76__newDeadline : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_76__newDeadline);
        
        warp_external_input_check_address(__warp_75__user);
        
        warp_external_input_check_int256(__warp_74__id);
        
        let (__warp_se_211) = get_caller_address();
        
        let (__warp_se_212) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_211);
        
        let (__warp_se_213) = WS1_READ_felt(__warp_se_212);
        
        let (__warp_se_214) = warp_eq(__warp_se_213, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_214 = 1;
        }
        
        let (__warp_se_215) = WSM19_Storage_14a18fd6_rightsPeriod(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_216) = WS0_READ_warp_id(__warp_se_215);
        
        let (__warp_se_217) = WS3_INDEX_Uint256_to_warp_id(__warp_se_216, __warp_74__id);
        
        let (__warp_se_218) = WS0_READ_warp_id(__warp_se_217);
        
        let (__warp_se_219) = WS2_INDEX_felt_to_Uint256(__warp_se_218, __warp_75__user);
        
        WS_WRITE1(__warp_se_219, __warp_76__newDeadline);
        
        
        
        return ();

    }


    @view
    func validated_2eb222b0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_77__id : Uint256, __warp_78__platform : felt, __warp_79__user : felt)-> (__warp_80 : felt){
    alloc_locals;


        
        warp_external_input_check_address(__warp_79__user);
        
        warp_external_input_check_address(__warp_78__platform);
        
        warp_external_input_check_int256(__warp_77__id);
        
        let (__warp_se_220) = WSM20_Storage_14a18fd6_validated(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_221) = WS0_READ_warp_id(__warp_se_220);
        
        let (__warp_se_222) = WS3_INDEX_Uint256_to_warp_id(__warp_se_221, __warp_77__id);
        
        let (__warp_se_223) = WS0_READ_warp_id(__warp_se_222);
        
        let (__warp_se_224) = WS4_INDEX_felt_to_warp_id(__warp_se_223, __warp_78__platform);
        
        let (__warp_se_225) = WS0_READ_warp_id(__warp_se_224);
        
        let (__warp_se_226) = WS0_INDEX_felt_to_felt(__warp_se_225, __warp_79__user);
        
        let (__warp_se_227) = WS1_READ_felt(__warp_se_226);
        
        
        
        return (__warp_se_227,);

    }


    @external
    func setValidated_c85480f7{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_81__id : Uint256, __warp_82__platform : felt, __warp_83__user : felt, __warp_84__validated : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_bool(__warp_84__validated);
        
        warp_external_input_check_address(__warp_83__user);
        
        warp_external_input_check_address(__warp_82__platform);
        
        warp_external_input_check_int256(__warp_81__id);
        
        let (__warp_se_228) = get_caller_address();
        
        let (__warp_se_229) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_228);
        
        let (__warp_se_230) = WS1_READ_felt(__warp_se_229);
        
        let (__warp_se_231) = warp_eq(__warp_se_230, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_231 = 1;
        }
        
        let (__warp_se_232) = WSM20_Storage_14a18fd6_validated(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_233) = WS0_READ_warp_id(__warp_se_232);
        
        let (__warp_se_234) = WS3_INDEX_Uint256_to_warp_id(__warp_se_233, __warp_81__id);
        
        let (__warp_se_235) = WS0_READ_warp_id(__warp_se_234);
        
        let (__warp_se_236) = WS4_INDEX_felt_to_warp_id(__warp_se_235, __warp_82__platform);
        
        let (__warp_se_237) = WS0_READ_warp_id(__warp_se_236);
        
        let (__warp_se_238) = WS0_INDEX_felt_to_felt(__warp_se_237, __warp_83__user);
        
        WS_WRITE0(__warp_se_238, __warp_84__validated);
        
        
        
        return ();

    }


    @view
    func selectorToFacetAndPositionFacet_bb9f8361{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_85__selector : felt)-> (__warp_86 : felt){
    alloc_locals;


        
        warp_external_input_check_int32(__warp_85__selector);
        
        let (__warp_se_239) = WSM22_Storage_14a18fd6_selectorToFacetAndPosition(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_240) = WS0_READ_warp_id(__warp_se_239);
        
        let (__warp_se_241) = warp_bytes_widen_256(__warp_85__selector, 224);
        
        let (__warp_se_242) = WS6_INDEX_Uint256_to_FacetAddressAndPosition_80522e2c(__warp_se_240, __warp_se_241);
        
        let (__warp_se_243) = WSM21_FacetAddressAndPosition_80522e2c_facetAddress(__warp_se_242);
        
        let (__warp_se_244) = WS1_READ_felt(__warp_se_243);
        
        
        
        return (__warp_se_244,);

    }


    @view
    func selectorToFacetAndPositionPosition_b1babb38{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_87__selector : felt)-> (__warp_88 : felt){
    alloc_locals;


        
        warp_external_input_check_int32(__warp_87__selector);
        
        let (__warp_se_245) = WSM22_Storage_14a18fd6_selectorToFacetAndPosition(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_246) = WS0_READ_warp_id(__warp_se_245);
        
        let (__warp_se_247) = warp_bytes_widen_256(__warp_87__selector, 224);
        
        let (__warp_se_248) = WS6_INDEX_Uint256_to_FacetAddressAndPosition_80522e2c(__warp_se_246, __warp_se_247);
        
        let (__warp_se_249) = WSM23_FacetAddressAndPosition_80522e2c_functionSelectorPosition(__warp_se_248);
        
        let (__warp_se_250) = WS1_READ_felt(__warp_se_249);
        
        
        
        return (__warp_se_250,);

    }


    @external
    func deleteSelectorToFacetAndPosition_3770ef2c{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_89__selector : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_int32(__warp_89__selector);
        
        let (__warp_se_251) = get_caller_address();
        
        let (__warp_se_252) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_251);
        
        let (__warp_se_253) = WS1_READ_felt(__warp_se_252);
        
        let (__warp_se_254) = warp_eq(__warp_se_253, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_254 = 1;
        }
        
        let (__warp_se_255) = WSM22_Storage_14a18fd6_selectorToFacetAndPosition(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_256) = WS0_READ_warp_id(__warp_se_255);
        
        let (__warp_se_257) = warp_bytes_widen_256(__warp_89__selector, 224);
        
        let (__warp_se_258) = WS6_INDEX_Uint256_to_FacetAddressAndPosition_80522e2c(__warp_se_256, __warp_se_257);
        
        WS_STRUCT_FacetAddressAndPosition_DELETE(__warp_se_258);
        
        
        
        return ();

    }


    @external
    func setSelectorToFacetAndPosition_23194fa2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_90__selector : Uint256, __warp_91__facetAddress : felt, __warp_92__position : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_int96(__warp_92__position);
        
        warp_external_input_check_address(__warp_91__facetAddress);
        
        warp_external_input_check_int256(__warp_90__selector);
        
        let (__warp_se_259) = get_caller_address();
        
        let (__warp_se_260) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_259);
        
        let (__warp_se_261) = WS1_READ_felt(__warp_se_260);
        
        let (__warp_se_262) = warp_eq(__warp_se_261, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_262 = 1;
        }
        
        let (__warp_se_263) = WSM22_Storage_14a18fd6_selectorToFacetAndPosition(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_264) = WS0_READ_warp_id(__warp_se_263);
        
        let (__warp_se_265) = WS6_INDEX_Uint256_to_FacetAddressAndPosition_80522e2c(__warp_se_264, __warp_90__selector);
        
        let (__warp_se_266) = WSM23_FacetAddressAndPosition_80522e2c_functionSelectorPosition(__warp_se_265);
        
        WS_WRITE0(__warp_se_266, __warp_92__position);
        
        let (__warp_se_267) = WSM22_Storage_14a18fd6_selectorToFacetAndPosition(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_268) = WS0_READ_warp_id(__warp_se_267);
        
        let (__warp_se_269) = WS6_INDEX_Uint256_to_FacetAddressAndPosition_80522e2c(__warp_se_268, __warp_90__selector);
        
        let (__warp_se_270) = WSM21_FacetAddressAndPosition_80522e2c_facetAddress(__warp_se_269);
        
        WS_WRITE0(__warp_se_270, __warp_91__facetAddress);
        
        
        
        return ();

    }


    @view
    func facetFunctionSelectorsSelectors_b09120cc{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_93__facet : felt)-> (__warp_94_len : felt, __warp_94 : Uint256*){
    alloc_locals;


        
        warp_external_input_check_address(__warp_93__facet);
        
        let (__warp_se_271) = WSM25_Storage_14a18fd6_facetFunctionSelectors(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_272) = WS0_READ_warp_id(__warp_se_271);
        
        let (__warp_se_273) = WS7_INDEX_felt_to_FacetFunctionSelectors_ba2cb0c5(__warp_se_272, __warp_93__facet);
        
        let (__warp_se_274) = WSM24_FacetFunctionSelectors_ba2cb0c5_functionSelectors(__warp_se_273);
        
        let (__warp_se_275) = WS0_READ_warp_id(__warp_se_274);
        
        let (__warp_se_276) = ws_dynamic_array_to_calldata1(__warp_se_275);
        
        
        
        return (__warp_se_276.len, __warp_se_276.ptr,);

    }


    @view
    func facetFunctionSelectorsPosition_56c6bb46{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_95__facet : felt)-> (__warp_96 : Uint256){
    alloc_locals;


        
        warp_external_input_check_address(__warp_95__facet);
        
        let (__warp_se_277) = WSM25_Storage_14a18fd6_facetFunctionSelectors(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_278) = WS0_READ_warp_id(__warp_se_277);
        
        let (__warp_se_279) = WS7_INDEX_felt_to_FacetFunctionSelectors_ba2cb0c5(__warp_se_278, __warp_95__facet);
        
        let (__warp_se_280) = WSM26_FacetFunctionSelectors_ba2cb0c5_facetAddressPosition(__warp_se_279);
        
        let (__warp_se_281) = WS2_READ_Uint256(__warp_se_280);
        
        
        
        return (__warp_se_281,);

    }


    @external
    func deleteFacetFunctionSelectors_a4f27a1a{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_97__facet : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_address(__warp_97__facet);
        
        let (__warp_se_282) = get_caller_address();
        
        let (__warp_se_283) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_282);
        
        let (__warp_se_284) = WS1_READ_felt(__warp_se_283);
        
        let (__warp_se_285) = warp_eq(__warp_se_284, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_285 = 1;
        }
        
        let (__warp_se_286) = WSM25_Storage_14a18fd6_facetFunctionSelectors(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_287) = WS0_READ_warp_id(__warp_se_286);
        
        let (__warp_se_288) = WS7_INDEX_felt_to_FacetFunctionSelectors_ba2cb0c5(__warp_se_287, __warp_97__facet);
        
        let (__warp_se_289) = WSM26_FacetFunctionSelectors_ba2cb0c5_facetAddressPosition(__warp_se_288);
        
        WS_WRITE1(__warp_se_289, Uint256(low=0, high=0));
        
        
        
        return ();

    }


    @external
    func setFacetFunctionSelectors_2ba2878a{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_98__facet : felt, __warp_99__selectors_len : felt, __warp_99__selectors : Uint256*, __warp_100__position : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_100__position);
        
        extern_input_check1(__warp_99__selectors_len, __warp_99__selectors);
        
        warp_external_input_check_address(__warp_98__facet);
        
        local __warp_99__selectors_dstruct : cd_dynarray_Uint256 = cd_dynarray_Uint256(__warp_99__selectors_len, __warp_99__selectors);
        
        let (__warp_se_290) = get_caller_address();
        
        let (__warp_se_291) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_290);
        
        let (__warp_se_292) = WS1_READ_felt(__warp_se_291);
        
        let (__warp_se_293) = warp_eq(__warp_se_292, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_293 = 1;
        }
        
        let (__warp_se_294) = WSM25_Storage_14a18fd6_facetFunctionSelectors(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_295) = WS0_READ_warp_id(__warp_se_294);
        
        let (__warp_se_296) = WS7_INDEX_felt_to_FacetFunctionSelectors_ba2cb0c5(__warp_se_295, __warp_98__facet);
        
        let (__warp_se_297) = WSM24_FacetFunctionSelectors_ba2cb0c5_functionSelectors(__warp_se_296);
        
        let (__warp_se_298) = WS0_READ_warp_id(__warp_se_297);
        
        cd_dynamic_array_to_storage1(__warp_se_298, __warp_99__selectors_dstruct);
        
        let (__warp_se_299) = WSM25_Storage_14a18fd6_facetFunctionSelectors(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_300) = WS0_READ_warp_id(__warp_se_299);
        
        let (__warp_se_301) = WS7_INDEX_felt_to_FacetFunctionSelectors_ba2cb0c5(__warp_se_300, __warp_98__facet);
        
        let (__warp_se_302) = WSM26_FacetFunctionSelectors_ba2cb0c5_facetAddressPosition(__warp_se_301);
        
        WS_WRITE1(__warp_se_302, __warp_100__position);
        
        
        
        return ();

    }


    @view
    func facetAddresses_52ef6b2c{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_101_len : felt, __warp_101 : felt*){
    alloc_locals;


        
        let (__warp_se_303) = WSM27_Storage_14a18fd6_facetAddresses(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_304) = WS0_READ_warp_id(__warp_se_303);
        
        let (__warp_se_305) = ws_dynamic_array_to_calldata3(__warp_se_304);
        
        
        
        return (__warp_se_305.len, __warp_se_305.ptr,);

    }


    @view
    func facetAddresses_5daf6a17{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_102__position : Uint256)-> (__warp_103 : felt){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_102__position);
        
        let (__warp_se_306) = WSM27_Storage_14a18fd6_facetAddresses(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_307) = WS0_READ_warp_id(__warp_se_306);
        
        let (__warp_se_308) = WARP_DARRAY1_felt_IDX(__warp_se_307, __warp_102__position);
        
        let (__warp_se_309) = WS1_READ_felt(__warp_se_308);
        
        
        
        return (__warp_se_309,);

    }


    @external
    func setFacetAddresses_70967870{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_104__facetAddresses_len : felt, __warp_104__facetAddresses : felt*)-> (){
    alloc_locals;


        
        extern_input_check3(__warp_104__facetAddresses_len, __warp_104__facetAddresses);
        
        local __warp_104__facetAddresses_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_104__facetAddresses_len, __warp_104__facetAddresses);
        
        let (__warp_se_310) = get_caller_address();
        
        let (__warp_se_311) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_310);
        
        let (__warp_se_312) = WS1_READ_felt(__warp_se_311);
        
        let (__warp_se_313) = warp_eq(__warp_se_312, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_313 = 1;
        }
        
        let (__warp_se_314) = WSM27_Storage_14a18fd6_facetAddresses(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_315) = WS0_READ_warp_id(__warp_se_314);
        
        cd_dynamic_array_to_storage3(__warp_se_315, __warp_104__facetAddresses_dstruct);
        
        
        
        return ();

    }


    @view
    func supportedInterfaces_1584ba38{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_105__interface : felt)-> (__warp_106 : felt){
    alloc_locals;


        
        warp_external_input_check_int32(__warp_105__interface);
        
        let (__warp_se_316) = WSM28_Storage_14a18fd6_supportedInterfaces(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_317) = WS0_READ_warp_id(__warp_se_316);
        
        let (__warp_se_318) = WS0_INDEX_felt_to_felt(__warp_se_317, __warp_105__interface);
        
        let (__warp_se_319) = WS1_READ_felt(__warp_se_318);
        
        
        
        return (__warp_se_319,);

    }


    @external
    func setSupportedInterfaces_cc499226{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_107__interface : felt, __warp_108__supported : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_bool(__warp_108__supported);
        
        warp_external_input_check_int32(__warp_107__interface);
        
        let (__warp_se_320) = get_caller_address();
        
        let (__warp_se_321) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_320);
        
        let (__warp_se_322) = WS1_READ_felt(__warp_se_321);
        
        let (__warp_se_323) = warp_eq(__warp_se_322, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_323 = 1;
        }
        
        let (__warp_se_324) = WSM28_Storage_14a18fd6_supportedInterfaces(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_325) = WS0_READ_warp_id(__warp_se_324);
        
        let (__warp_se_326) = WS0_INDEX_felt_to_felt(__warp_se_325, __warp_107__interface);
        
        WS_WRITE0(__warp_se_326, __warp_108__supported);
        
        
        
        return ();

    }


    @view
    func contractOwner_ce606ee0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_109 : felt){
    alloc_locals;


        
        let (__warp_se_327) = WSM29_Storage_14a18fd6_contractOwner(AppStorage.__warp_0_appStorage);
        
        let (__warp_se_328) = WS1_READ_felt(__warp_se_327);
        
        
        
        return (__warp_se_328,);

    }


    @external
    func setContractOwner_a34d42b8{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_110__newOwner : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_address(__warp_110__newOwner);
        
        let (__warp_se_329) = get_caller_address();
        
        let (__warp_se_330) = WS0_INDEX_felt_to_felt(AppStorage.__warp_2_allowedFacet, __warp_se_329);
        
        let (__warp_se_331) = WS1_READ_felt(__warp_se_330);
        
        let (__warp_se_332) = warp_eq(__warp_se_331, 1);
        
        with_attr error_message("not allowed facet"){
            assert __warp_se_332 = 1;
        }
        
        let (__warp_se_333) = WSM29_Storage_14a18fd6_contractOwner(AppStorage.__warp_0_appStorage);
        
        WS_WRITE0(__warp_se_333, __warp_110__newOwner);
        
        
        
        return ();

    }


    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_3__owner : felt){
    alloc_locals;
    WARP_USED_STORAGE.write(31);
    WARP_NAMEGEN.write(1);


        
        warp_external_input_check_address(__warp_3__owner);
        
        AppStorage.__warp_constructor_0(__warp_3__owner);
        
        
        
        return ();

    }

@storage_var
func WARP_STORAGE(index: felt) -> (val: felt){
}
@storage_var
func WARP_USED_STORAGE() -> (val: felt){
}
@storage_var
func WARP_NAMEGEN() -> (name: felt){
}
func readId{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (val: felt){
    alloc_locals;
    let (id) = WARP_STORAGE.read(loc);
    if (id == 0){
        let (id) = WARP_NAMEGEN.read();
        WARP_NAMEGEN.write(id + 1);
        WARP_STORAGE.write(loc, id + 1);
        return (id + 1,);
    }else{
        return (id,);
    }
}