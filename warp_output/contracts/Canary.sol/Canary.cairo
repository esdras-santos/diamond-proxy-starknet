%lang starknet


from warplib.memory import wm_alloc, wm_write_256, wm_dyn_array_length, wm_new, wm_to_felt_array
from starkware.cairo.common.uint256 import Uint256, uint256_sub, uint256_lt, uint256_eq, uint256_add
from starkware.cairo.common.dict import dict_write, dict_read
from warplib.maths.utils import narrow_safe, felt_to_uint256, uint256_to_address_felt
from warplib.maths.int_conversions import warp_uint256
from starkware.cairo.common.alloc import alloc
from warplib.maths.external_input_check_ints import warp_external_input_check_int256
from warplib.maths.external_input_check_address import warp_external_input_check_address
from warplib.maths.external_input_check_bool import warp_external_input_check_bool
from warplib.dynamic_arrays_util import fixed_bytes256_to_felt_dynamic_array, felt_array_to_warp_memory_array, fixed_bytes256_to_felt_dynamic_array_spl
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.keccak import felt_array_concat, pack_bytes_felt, warp_keccak
from starkware.starknet.common.syscalls import emit_event, get_caller_address, get_contract_address
from warplib.maths.gt import warp_gt256
from warplib.block_methods import warp_block_timestamp
from warplib.maths.lt import warp_lt256
from warplib.maths.mul import warp_mul256
from warplib.maths.div import warp_div256
from warplib.maths.sub import warp_sub256
from warplib.maths.add import warp_add256
from warplib.maths.eq import warp_eq256, warp_eq
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.cairo_keccak.keccak import finalize_keccak
from warplib.maths.ge import warp_ge256
from warplib.maths.neq import warp_neq


struct cd_dynarray_felt{
     len : felt ,
     ptr : felt*,
}

struct cd_dynarray_Uint256{
     len : felt ,
     ptr : Uint256*,
}

func WM0_d_arr{range_check_ptr, warp_memory: DictAccess*}() -> (loc: felt){
    alloc_locals;
    let (start) = wm_alloc(Uint256(0x2, 0x0));
wm_write_256{warp_memory=warp_memory}(start, Uint256(0x0, 0x0));
    return (start,);
}

func wm_to_storage0_elem{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(storage_name: felt, mem_loc : felt, length: Uint256) -> (){
    alloc_locals;
    if (length.low == 0 and length.high == 0){
        return ();
    }
    let (index) = uint256_sub(length, Uint256(1,0));
    let (storage_loc) = WARP_DARRAY0_felt.read(storage_name, index);
    let mem_loc = mem_loc - 1;
    if (storage_loc == 0){
        let (storage_loc) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(storage_loc + 1);
        WARP_DARRAY0_felt.write(storage_name, index, storage_loc);
    let (copy) = dict_read{dict_ptr=warp_memory}(mem_loc);
    WARP_STORAGE.write(storage_loc, copy);
    return wm_to_storage0_elem(storage_name, mem_loc, index);
    }else{
    let (copy) = dict_read{dict_ptr=warp_memory}(mem_loc);
    WARP_STORAGE.write(storage_loc, copy);
    return wm_to_storage0_elem(storage_name, mem_loc, index);
    }
}
func wm_to_storage0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt, mem_loc : felt) -> (loc : felt){
    alloc_locals;
    let (length) = WARP_DARRAY0_felt_LENGTH.read(loc);
    let (mem_length) = wm_dyn_array_length(mem_loc);
    WARP_DARRAY0_felt_LENGTH.write(loc, mem_length);
    let (narrowedLength) = narrow_safe(mem_length);
    wm_to_storage0_elem(loc, mem_loc + 2 + 1 * narrowedLength, mem_length);
    let (lesser) = uint256_lt(mem_length, length);
    if (lesser == 1){
       WS2_DYNAMIC_ARRAY_DELETE_elem(loc, mem_length, length);
       return (loc,);
    }else{
       return (loc,);
    }
}

func WS0_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS1_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    WARP_STORAGE.write(loc + 1, 0);
    return ();
}

func WS2_DYNAMIC_ARRAY_DELETE_elem{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt, index : Uint256, length : Uint256){
     alloc_locals;
     let (stop) = uint256_eq(index, length);
     if (stop == 1){
        return ();
     }
     let (elem_loc) = WARP_DARRAY0_felt.read(loc, index);
    WS3_DELETE(elem_loc);
     let (next_index, _) = uint256_add(index, Uint256(0x1, 0x0));
     return WS2_DYNAMIC_ARRAY_DELETE_elem(loc, next_index, length);
}
func WS2_DYNAMIC_ARRAY_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt){
   alloc_locals;
   let (length) = WARP_DARRAY0_felt_LENGTH.read(loc);
   WARP_DARRAY0_felt_LENGTH.write(loc, Uint256(0x0, 0x0));
   return WS2_DYNAMIC_ARRAY_DELETE_elem(loc, Uint256(0x0, 0x0), length);
}

func WS3_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WARP_DARRAY0_felt_IDX{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(ref: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (length) = WARP_DARRAY0_felt_LENGTH.read(ref);
    let (inRange) = uint256_lt(index, length);
    assert inRange = 1;
    let (existing) = WARP_DARRAY0_felt.read(ref, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_DARRAY0_felt.write(ref, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

func WARP_DARRAY1_Uint256_IDX{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(ref: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (length) = WARP_DARRAY1_Uint256_LENGTH.read(ref);
    let (inRange) = uint256_lt(index, length);
    assert inRange = 1;
    let (existing) = WARP_DARRAY1_Uint256.read(ref, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_DARRAY1_Uint256.write(ref, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

func WARP_DARRAY0_felt_POP{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (){
    alloc_locals;
    let (len) = WARP_DARRAY0_felt_LENGTH.read(loc);
    let (isEmpty) = uint256_eq(len, Uint256(0,0));
    assert isEmpty = 0;
    let (newLen) = uint256_sub(len, Uint256(1,0));
    WARP_DARRAY0_felt_LENGTH.write(loc, newLen);
    let (elem_loc) = WARP_DARRAY0_felt.read(loc, newLen);
    return WS0_DELETE(elem_loc);
}

func WARP_DARRAY1_Uint256_POP{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (){
    alloc_locals;
    let (len) = WARP_DARRAY1_Uint256_LENGTH.read(loc);
    let (isEmpty) = uint256_eq(len, Uint256(0,0));
    assert isEmpty = 0;
    let (newLen) = uint256_sub(len, Uint256(1,0));
    WARP_DARRAY1_Uint256_LENGTH.write(loc, newLen);
    let (elem_loc) = WARP_DARRAY1_Uint256.read(loc, newLen);
    return WS1_DELETE(elem_loc);
}

func WARP_DARRAY1_Uint256_PUSHV0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr: BitwiseBuiltin*}(loc: felt, value: Uint256) -> (){
    alloc_locals;
    let (len) = WARP_DARRAY1_Uint256_LENGTH.read(loc);
    let (newLen, carry) = uint256_add(len, Uint256(1,0));
    assert carry = 0;
    WARP_DARRAY1_Uint256_LENGTH.write(loc, newLen);
    let (existing) = WARP_DARRAY1_Uint256.read(loc, len);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_DARRAY1_Uint256.write(loc, len, used);
WS_WRITE0(used, value);
    }else{
WS_WRITE0(existing, value);
    }
    return ();
}

func WARP_DARRAY0_felt_PUSHV1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr: BitwiseBuiltin*}(loc: felt, value: felt) -> (){
    alloc_locals;
    let (len) = WARP_DARRAY0_felt_LENGTH.read(loc);
    let (newLen, carry) = uint256_add(len, Uint256(1,0));
    assert carry = 0;
    WARP_DARRAY0_felt_LENGTH.write(loc, newLen);
    let (existing) = WARP_DARRAY0_felt.read(loc, len);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_DARRAY0_felt.write(loc, len, used);
WS_WRITE1(used, value);
    }else{
WS_WRITE1(existing, value);
    }
    return ();
}

func WARP_DARRAY1_Uint256_PUSHV2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr: BitwiseBuiltin*}(loc: felt, value: Uint256) -> (){
    alloc_locals;
    let (len) = WARP_DARRAY1_Uint256_LENGTH.read(loc);
    let (newLen, carry) = uint256_add(len, Uint256(1,0));
    assert carry = 0;
    WARP_DARRAY1_Uint256_LENGTH.write(loc, newLen);
    let (existing) = WARP_DARRAY1_Uint256.read(loc, len);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_DARRAY1_Uint256.write(loc, len, used);
WS_WRITE0(used, value);
    }else{
WS_WRITE0(existing, value);
    }
    return ();
}

func WS0_READ_warp_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: felt){
    alloc_locals;
    let (read0) = readId(loc);
    return (read0,);
}

func WS1_READ_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: Uint256){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    let (read1) = WARP_STORAGE.read(loc + 1);
    return (Uint256(low=read0,high=read1),);
}

func WS2_READ_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: felt){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
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
   let (elem_loc) = WARP_DARRAY1_Uint256.read(loc, index_uint256);
   let (elem) = WS1_READ_Uint256(elem_loc);
   assert ptr[index] = elem;
   return ws_dynamic_array_to_calldata0_write(loc, index + 1, len, ptr);
}
func ws_dynamic_array_to_calldata0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt) -> (dyn_array_struct : cd_dynarray_Uint256){
   alloc_locals;
   let (len_uint256) = WARP_DARRAY1_Uint256_LENGTH.read(loc);
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
   ptr : felt*) -> (ptr : felt*){
   alloc_locals;
   if (len == index){
       return (ptr,);
   }
   let (index_uint256) = warp_uint256(index);
   let (elem_loc) = WARP_DARRAY0_felt.read(loc, index_uint256);
   let (elem) = WS2_READ_felt(elem_loc);
   assert ptr[index] = elem;
   return ws_dynamic_array_to_calldata1_write(loc, index + 1, len, ptr);
}
func ws_dynamic_array_to_calldata1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt) -> (dyn_array_struct : cd_dynarray_felt){
   alloc_locals;
   let (len_uint256) = WARP_DARRAY0_felt_LENGTH.read(loc);
   let len = len_uint256.low + len_uint256.high*128;
   let (ptr : felt*) = alloc();
   let (ptr : felt*) = ws_dynamic_array_to_calldata1_write(loc, 0, len, ptr);
   let dyn_array_struct = cd_dynarray_felt(len, ptr);
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
   let (elem_loc) = WARP_DARRAY0_felt.read(loc, index_uint256);
   let (elem) = WS2_READ_felt(elem_loc);
   assert ptr[index] = elem;
   return ws_dynamic_array_to_calldata2_write(loc, index + 1, len, ptr);
}
func ws_dynamic_array_to_calldata2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt) -> (dyn_array_struct : cd_dynarray_felt){
   alloc_locals;
   let (len_uint256) = WARP_DARRAY0_felt_LENGTH.read(loc);
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
   ptr : Uint256*) -> (ptr : Uint256*){
   alloc_locals;
   if (len == index){
       return (ptr,);
   }
   let (index_uint256) = warp_uint256(index);
   let (elem_loc) = WARP_DARRAY1_Uint256.read(loc, index_uint256);
   let (elem) = WS1_READ_Uint256(elem_loc);
   assert ptr[index] = elem;
   return ws_dynamic_array_to_calldata3_write(loc, index + 1, len, ptr);
}
func ws_dynamic_array_to_calldata3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt) -> (dyn_array_struct : cd_dynarray_Uint256){
   alloc_locals;
   let (len_uint256) = WARP_DARRAY1_Uint256_LENGTH.read(loc);
   let len = len_uint256.low + len_uint256.high*128;
   let (ptr : Uint256*) = alloc();
   let (ptr : Uint256*) = ws_dynamic_array_to_calldata3_write(loc, 0, len, ptr);
   let dyn_array_struct = cd_dynarray_Uint256(len, ptr);
   return (dyn_array_struct,);
}

func WS_WRITE0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: Uint256) -> (res: Uint256){
    WARP_STORAGE.write(loc, value.low);
    WARP_STORAGE.write(loc + 1, value.high);
    return (value,);
}

func WS_WRITE1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: felt) -> (res: felt){
    WARP_STORAGE.write(loc, value);
    return (value,);
}

func cd_to_memory0_elem{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(calldata: felt*, mem_start: felt, length: felt){
    alloc_locals;
    if (length == 0){
        return ();
    }
dict_write{dict_ptr=warp_memory}(mem_start, calldata[0]);
    return cd_to_memory0_elem(calldata + 1, mem_start + 1, length - 1);
}
func cd_to_memory0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(calldata : cd_dynarray_felt) -> (mem_loc: felt){
    alloc_locals;
    let (len256) = felt_to_uint256(calldata.len);
    let (mem_start) = wm_new(len256, Uint256(0x1, 0x0));
    cd_to_memory0_elem(calldata.ptr, mem_start + 2, calldata.len);
    return (mem_start,);
}

func abi_encode0{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(param0 : felt, param1 : Uint256) -> (result_ptr : felt){
  alloc_locals;
  let bytes_index : felt = 0;
  let bytes_offset : felt = 64;
  let (bytes_array : felt*) = alloc();
let (param0256) = felt_to_uint256(param0);
fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, param0256);
let bytes_index = bytes_index + 32;
fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, param1);
let bytes_index = bytes_index + 32;
  let (max_length256) = felt_to_uint256(bytes_offset);
  let (mem_ptr) = wm_new(max_length256, Uint256(0x1, 0x0));
  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_offset);
  return (mem_ptr,);
}

func abi_encode1{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(param0 : felt) -> (result_ptr : felt){
  alloc_locals;
  let bytes_index : felt = 0;
  let bytes_offset : felt = 32;
  let (bytes_array : felt*) = alloc();
let (param0256) = felt_to_uint256(param0);
fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, param0256);
let bytes_index = bytes_index + 32;
  let (max_length256) = felt_to_uint256(bytes_offset);
  let (mem_ptr) = wm_new(max_length256, Uint256(0x1, 0x0));
  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_offset);
  return (mem_ptr,);
}

func abi_encode2{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(param0 : Uint256) -> (result_ptr : felt){
  alloc_locals;
  let bytes_index : felt = 0;
  let bytes_offset : felt = 32;
  let (bytes_array : felt*) = alloc();
fixed_bytes256_to_felt_dynamic_array(bytes_index, bytes_array, 0, param0);
let bytes_index = bytes_index + 32;
  let (max_length256) = felt_to_uint256(bytes_offset);
  let (mem_ptr) = wm_new(max_length256, Uint256(0x1, 0x0));
  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_offset);
  return (mem_ptr,);
}

func _emit_RoyaltiesWithdraw_644800e6{syscall_ptr: felt*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*, keccak_ptr: felt*}(param0 : felt, param1 : Uint256){
   alloc_locals;
   // keys arrays
   let keys_len: felt = 0;
   let (keys: felt*) = alloc();
   //Insert topic
    let (topic256: Uint256) = felt_to_uint256(987259207606944585019788593394946382033643766016660024770182144915957184685);// keccak of event signature: RoyaltiesWithdraw_644800e6(address,uint256)
    let (keys_len: felt) = fixed_bytes256_to_felt_dynamic_array_spl(keys_len, keys, 0, topic256);
   // keys: pack 31 byte felts into a single 248 bit felt
   let (keys_len: felt, keys: felt*) = pack_bytes_felt(31, 1, keys_len, keys);
   // data arrays
   let data_len: felt = 0;
   let (data: felt*) = alloc();
   let (mem_encode: felt) = abi_encode1(param0);
   let (encode_bytes_len: felt, encode_bytes: felt*) = wm_to_felt_array(mem_encode);
   let (data_len: felt) = felt_array_concat(encode_bytes_len, 0, encode_bytes, data_len, data);
   let (mem_encode: felt) = abi_encode2(param1);
   let (encode_bytes_len: felt, encode_bytes: felt*) = wm_to_felt_array(mem_encode);
   let (data_len: felt) = felt_array_concat(encode_bytes_len, 0, encode_bytes, data_len, data);
   // data: pack 31 bytes felts into a single 248 bits felt
   let (data_len: felt, data: felt*) = pack_bytes_felt(31, 1, data_len, data);
   emit_event(keys_len, keys, data_len, data);
   return ();
}

func _emit_GetRight_4215fdfe{syscall_ptr: felt*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*, keccak_ptr: felt*}(param0 : Uint256, param1 : Uint256, param2 : felt){
   alloc_locals;
   // keys arrays
   let keys_len: felt = 0;
   let (keys: felt*) = alloc();
   //Insert topic
    let (topic256: Uint256) = felt_to_uint256(1142036649621181151271316921893255235550601329385880426110078296287889148731);// keccak of event signature: GetRight_4215fdfe(uint256,uint256,address)
    let (keys_len: felt) = fixed_bytes256_to_felt_dynamic_array_spl(keys_len, keys, 0, topic256);
   // keys: pack 31 byte felts into a single 248 bit felt
   let (keys_len: felt, keys: felt*) = pack_bytes_felt(31, 1, keys_len, keys);
   // data arrays
   let data_len: felt = 0;
   let (data: felt*) = alloc();
   let (mem_encode: felt) = abi_encode2(param0);
   let (encode_bytes_len: felt, encode_bytes: felt*) = wm_to_felt_array(mem_encode);
   let (data_len: felt) = felt_array_concat(encode_bytes_len, 0, encode_bytes, data_len, data);
   let (mem_encode: felt) = abi_encode2(param1);
   let (encode_bytes_len: felt, encode_bytes: felt*) = wm_to_felt_array(mem_encode);
   let (data_len: felt) = felt_array_concat(encode_bytes_len, 0, encode_bytes, data_len, data);
   let (mem_encode: felt) = abi_encode1(param2);
   let (encode_bytes_len: felt, encode_bytes: felt*) = wm_to_felt_array(mem_encode);
   let (data_len: felt) = felt_array_concat(encode_bytes_len, 0, encode_bytes, data_len, data);
   // data: pack 31 bytes felts into a single 248 bits felt
   let (data_len: felt, data: felt*) = pack_bytes_felt(31, 1, data_len, data);
   emit_event(keys_len, keys, data_len, data);
   return ();
}

func _emit_DepositedNFT_8b187cf9{syscall_ptr: felt*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*, keccak_ptr: felt*}(param0 : felt, param1 : Uint256){
   alloc_locals;
   // keys arrays
   let keys_len: felt = 0;
   let (keys: felt*) = alloc();
   //Insert topic
    let (topic256: Uint256) = felt_to_uint256(906121910891068680673922152618919759120668638556286754227300728593035886745);// keccak of event signature: DepositedNFT_8b187cf9(address,uint256)
    let (keys_len: felt) = fixed_bytes256_to_felt_dynamic_array_spl(keys_len, keys, 0, topic256);
   // keys: pack 31 byte felts into a single 248 bit felt
   let (keys_len: felt, keys: felt*) = pack_bytes_felt(31, 1, keys_len, keys);
   // data arrays
   let data_len: felt = 0;
   let (data: felt*) = alloc();
   let (mem_encode: felt) = abi_encode1(param0);
   let (encode_bytes_len: felt, encode_bytes: felt*) = wm_to_felt_array(mem_encode);
   let (data_len: felt) = felt_array_concat(encode_bytes_len, 0, encode_bytes, data_len, data);
   let (mem_encode: felt) = abi_encode2(param1);
   let (encode_bytes_len: felt, encode_bytes: felt*) = wm_to_felt_array(mem_encode);
   let (data_len: felt) = felt_array_concat(encode_bytes_len, 0, encode_bytes, data_len, data);
   // data: pack 31 bytes felts into a single 248 bits felt
   let (data_len: felt, data: felt*) = pack_bytes_felt(31, 1, data_len, data);
   emit_event(keys_len, keys, data_len, data);
   return ();
}

@storage_var
func WARP_DARRAY0_felt(name: felt, index: Uint256) -> (resLoc : felt){
}
@storage_var
func WARP_DARRAY0_felt_LENGTH(name: felt) -> (index: Uint256){
}

@storage_var
func WARP_DARRAY1_Uint256(name: felt, index: Uint256) -> (resLoc : felt){
}
@storage_var
func WARP_DARRAY1_Uint256_LENGTH(name: felt) -> (index: Uint256){
}

@storage_var
func WARP_MAPPING0(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS0_INDEX_Uint256_to_warp_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
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
func WARP_MAPPING1(name: felt, index: felt) -> (resLoc : felt){
}
func WS1_INDEX_felt_to_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
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
func WARP_MAPPING2(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS2_INDEX_Uint256_to_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
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
func WARP_MAPPING3(name: felt, index: felt) -> (resLoc : felt){
}
func WS3_INDEX_felt_to_warp_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
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
func WARP_MAPPING4(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS4_INDEX_Uint256_to_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
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
func WARP_MAPPING5(name: felt, index: felt) -> (resLoc : felt){
}
func WS5_INDEX_felt_to_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
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


// Contract Def Canary


@event
func GetRight_4215fdfe(_rightid : Uint256, _period : Uint256, _who : felt){
}


@event
func DepositedNFT_8b187cf9(_erc721 : felt, _nftid : Uint256){
}


@event
func RoyaltiesWithdraw_644800e6(owner : felt, amount : Uint256){
}

namespace Canary{

    // Dynamic variables - Arrays and Maps

    const __warp_3_availableRights = 1;

    const __warp_4_highestDeadline = 2;

    const dividends = 3;

    const beforeProposal = 4;

    const __warp_5_rightsOrigin = 5;

    const __warp_6_rightUri = 6;

    const __warp_7_dailyPrice = 7;

    const __warp_8_maxRightsHolders = 8;

    const __warp_9_maxtime = 9;

    const __warp_10_rightsOver = 10;

    const __warp_11_properties = 11;

    const __warp_12_isAvailable = 12;

    const __warp_13_owner = 13;

    const __warp_14_rightHolders = 14;

    const __warp_15_deadline = 15;

    const __warp_16_rightsPeriod = 16;

    const __warp_17_validated = 17;

    // Static variables

    const __warp_0_treasury = 0;

    const period = 2;

    const __warp_1_governanceToken = 4;

    const __warp_2_contractOwner = 5;


    func __warp_while1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_31__rightid : Uint256, __warp_33_j : Uint256, __warp_32_amountToWithdraw : Uint256)-> (__warp_31__rightid : Uint256, __warp_33_j : Uint256, __warp_32_amountToWithdraw : Uint256){
    alloc_locals;


        
            
            let (__warp_se_0) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
            
            let (__warp_se_1) = WS0_READ_warp_id(__warp_se_0);
            
            let (__warp_se_2) = WARP_DARRAY0_felt_LENGTH.read(__warp_se_1);
            
            let (__warp_se_3) = warp_gt256(__warp_se_2, Uint256(low=0, high=0));
            
            if (__warp_se_3 != 0){
            
                
                    
                    let (__warp_se_4) = WS0_INDEX_Uint256_to_warp_id(__warp_15_deadline, __warp_31__rightid);
                    
                    let (__warp_se_5) = WS0_READ_warp_id(__warp_se_4);
                    
                    let (__warp_se_6) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                    
                    let (__warp_se_7) = WS0_READ_warp_id(__warp_se_6);
                    
                    let (__warp_se_8) = WARP_DARRAY0_felt_IDX(__warp_se_7, __warp_33_j);
                    
                    let (__warp_se_9) = WS2_READ_felt(__warp_se_8);
                    
                    let (__warp_se_10) = WS1_INDEX_felt_to_Uint256(__warp_se_5, __warp_se_9);
                    
                    let (__warp_35_dl) = WS1_READ_Uint256(__warp_se_10);
                    
                    let (__warp_se_11) = WS0_INDEX_Uint256_to_warp_id(__warp_16_rightsPeriod, __warp_31__rightid);
                    
                    let (__warp_se_12) = WS0_READ_warp_id(__warp_se_11);
                    
                    let (__warp_se_13) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                    
                    let (__warp_se_14) = WS0_READ_warp_id(__warp_se_13);
                    
                    let (__warp_se_15) = WARP_DARRAY0_felt_IDX(__warp_se_14, __warp_33_j);
                    
                    let (__warp_se_16) = WS2_READ_felt(__warp_se_15);
                    
                    let (__warp_se_17) = WS1_INDEX_felt_to_Uint256(__warp_se_12, __warp_se_16);
                    
                    let (__warp_36_rp) = WS1_READ_Uint256(__warp_se_17);
                    
                    let (__warp_se_18) = warp_block_timestamp();
                    
                    let (__warp_se_19) = warp_lt256(__warp_35_dl, __warp_se_18);
                    
                    if (__warp_se_19 != 0){
                    
                        
                            
                            let (__warp_se_20) = WS2_INDEX_Uint256_to_Uint256(__warp_7_dailyPrice, __warp_31__rightid);
                            
                            let (__warp_se_21) = WS1_READ_Uint256(__warp_se_20);
                            
                            let (__warp_37_amount) = warp_mul256(__warp_se_21, __warp_36_rp);
                            
                            let (__warp_se_22) = warp_mul256(__warp_37_amount, Uint256(low=500, high=0));
                            
                            let (__warp_se_23) = warp_div256(__warp_se_22, Uint256(low=10000, high=0));
                            
                            let (__warp_se_24) = warp_sub256(__warp_37_amount, __warp_se_23);
                            
                            let (__warp_se_25) = warp_add256(__warp_32_amountToWithdraw, __warp_se_24);
                            
                            let __warp_32_amountToWithdraw = __warp_se_25;
                            
                                
                                let __warp_38_i = Uint256(low=0, high=0);
                                
                                    
                                    let (__warp_tv_0, __warp_tv_1, __warp_tv_2) = __warp_while0(__warp_38_i, __warp_31__rightid, __warp_33_j);
                                    
                                    let __warp_33_j = __warp_tv_2;
                                    
                                    let __warp_31__rightid = __warp_tv_1;
                                    
                                    let __warp_38_i = __warp_tv_0;
                            
                            let (__warp_se_26) = WS0_INDEX_Uint256_to_warp_id(__warp_15_deadline, __warp_31__rightid);
                            
                            let (__warp_se_27) = WS0_READ_warp_id(__warp_se_26);
                            
                            let (__warp_se_28) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                            
                            let (__warp_se_29) = WS0_READ_warp_id(__warp_se_28);
                            
                            let (__warp_se_30) = WARP_DARRAY0_felt_IDX(__warp_se_29, __warp_33_j);
                            
                            let (__warp_se_31) = WS2_READ_felt(__warp_se_30);
                            
                            let (__warp_se_32) = WS1_INDEX_felt_to_Uint256(__warp_se_27, __warp_se_31);
                            
                            WS_WRITE0(__warp_se_32, Uint256(low=0, high=0));
                            
                            let (__warp_se_33) = WS0_INDEX_Uint256_to_warp_id(__warp_16_rightsPeriod, __warp_31__rightid);
                            
                            let (__warp_se_34) = WS0_READ_warp_id(__warp_se_33);
                            
                            let (__warp_se_35) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                            
                            let (__warp_se_36) = WS0_READ_warp_id(__warp_se_35);
                            
                            let (__warp_se_37) = WARP_DARRAY0_felt_IDX(__warp_se_36, __warp_33_j);
                            
                            let (__warp_se_38) = WS2_READ_felt(__warp_se_37);
                            
                            let (__warp_se_39) = WS1_INDEX_felt_to_Uint256(__warp_se_34, __warp_se_38);
                            
                            WS_WRITE0(__warp_se_39, Uint256(low=0, high=0));
                            
                            let (__warp_se_40) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                            
                            let (__warp_se_41) = WS0_READ_warp_id(__warp_se_40);
                            
                            let (__warp_se_42) = WARP_DARRAY0_felt_IDX(__warp_se_41, __warp_33_j);
                            
                            let (__warp_se_43) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                            
                            let (__warp_se_44) = WS0_READ_warp_id(__warp_se_43);
                            
                            let (__warp_se_45) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                            
                            let (__warp_se_46) = WS0_READ_warp_id(__warp_se_45);
                            
                            let (__warp_se_47) = WARP_DARRAY0_felt_LENGTH.read(__warp_se_46);
                            
                            let (__warp_se_48) = warp_sub256(__warp_se_47, Uint256(low=1, high=0));
                            
                            let (__warp_se_49) = WARP_DARRAY0_felt_IDX(__warp_se_44, __warp_se_48);
                            
                            let (__warp_se_50) = WS2_READ_felt(__warp_se_49);
                            
                            WS_WRITE1(__warp_se_42, __warp_se_50);
                            
                            let (__warp_se_51) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                            
                            let (__warp_se_52) = WS0_READ_warp_id(__warp_se_51);
                            
                            WARP_DARRAY0_felt_POP(__warp_se_52);
                            
                            let (__warp_se_53) = WS2_INDEX_Uint256_to_Uint256(__warp_8_maxRightsHolders, __warp_31__rightid);
                            
                            let (__warp_se_54) = WS2_INDEX_Uint256_to_Uint256(__warp_8_maxRightsHolders, __warp_31__rightid);
                            
                            let (__warp_se_55) = WS1_READ_Uint256(__warp_se_54);
                            
                            let (__warp_se_56) = warp_add256(__warp_se_55, Uint256(low=1, high=0));
                            
                            WS_WRITE0(__warp_se_53, __warp_se_56);
                        
                        let (__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw) = __warp_while1_if_part2(__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw);
                        
                        
                        
                        return (__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw);
                    }else{
                    
                        
                        let (__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw) = __warp_while1_if_part2(__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw);
                        
                        
                        
                        return (__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw);
                    }
            }else{
            
                
                    
                    let __warp_31__rightid = __warp_31__rightid;
                    
                    let __warp_33_j = __warp_33_j;
                    
                    let __warp_32_amountToWithdraw = __warp_32_amountToWithdraw;
                    
                    
                    
                    return (__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw);
            }

    }


    func __warp_while1_if_part2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_31__rightid : Uint256, __warp_33_j : Uint256, __warp_32_amountToWithdraw : Uint256)-> (__warp_31__rightid : Uint256, __warp_33_j : Uint256, __warp_32_amountToWithdraw : Uint256){
    alloc_locals;


        
        
        
        let (__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw) = __warp_while1_if_part1(__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw);
        
        
        
        return (__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw);

    }


    func __warp_while1_if_part1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_31__rightid : Uint256, __warp_33_j : Uint256, __warp_32_amountToWithdraw : Uint256)-> (__warp_31__rightid : Uint256, __warp_33_j : Uint256, __warp_32_amountToWithdraw : Uint256){
    alloc_locals;


        
        
        
        let (__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw) = __warp_while1(__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw);
        
        
        
        return (__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw);

    }


    func __warp_while0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_38_i : Uint256, __warp_31__rightid : Uint256, __warp_33_j : Uint256)-> (__warp_38_i : Uint256, __warp_31__rightid : Uint256, __warp_33_j : Uint256){
    alloc_locals;


        
            
            let (__warp_se_57) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
            
            let (__warp_se_58) = WS0_READ_warp_id(__warp_se_57);
            
            let (__warp_se_59) = WARP_DARRAY0_felt_IDX(__warp_se_58, __warp_33_j);
            
            let (__warp_se_60) = WS2_READ_felt(__warp_se_59);
            
            let (__warp_se_61) = WS3_INDEX_felt_to_warp_id(__warp_10_rightsOver, __warp_se_60);
            
            let (__warp_se_62) = WS0_READ_warp_id(__warp_se_61);
            
            let (__warp_se_63) = WARP_DARRAY1_Uint256_LENGTH.read(__warp_se_62);
            
            let (__warp_se_64) = warp_lt256(__warp_38_i, __warp_se_63);
            
            if (__warp_se_64 != 0){
            
                
                    
                        
                        let (__warp_se_65) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                        
                        let (__warp_se_66) = WS0_READ_warp_id(__warp_se_65);
                        
                        let (__warp_se_67) = WARP_DARRAY0_felt_IDX(__warp_se_66, __warp_33_j);
                        
                        let (__warp_se_68) = WS2_READ_felt(__warp_se_67);
                        
                        let (__warp_se_69) = WS3_INDEX_felt_to_warp_id(__warp_10_rightsOver, __warp_se_68);
                        
                        let (__warp_se_70) = WS0_READ_warp_id(__warp_se_69);
                        
                        let (__warp_se_71) = WARP_DARRAY1_Uint256_IDX(__warp_se_70, __warp_38_i);
                        
                        let (__warp_se_72) = WS1_READ_Uint256(__warp_se_71);
                        
                        let (__warp_se_73) = warp_eq256(__warp_se_72, __warp_31__rightid);
                        
                        if (__warp_se_73 != 0){
                        
                            
                                
                                let (__warp_se_74) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                                
                                let (__warp_se_75) = WS0_READ_warp_id(__warp_se_74);
                                
                                let (__warp_se_76) = WARP_DARRAY0_felt_IDX(__warp_se_75, __warp_33_j);
                                
                                let (__warp_se_77) = WS2_READ_felt(__warp_se_76);
                                
                                let (__warp_se_78) = WS3_INDEX_felt_to_warp_id(__warp_10_rightsOver, __warp_se_77);
                                
                                let (__warp_se_79) = WS0_READ_warp_id(__warp_se_78);
                                
                                let (__warp_se_80) = WARP_DARRAY1_Uint256_IDX(__warp_se_79, __warp_38_i);
                                
                                let (__warp_se_81) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                                
                                let (__warp_se_82) = WS0_READ_warp_id(__warp_se_81);
                                
                                let (__warp_se_83) = WARP_DARRAY0_felt_IDX(__warp_se_82, __warp_33_j);
                                
                                let (__warp_se_84) = WS2_READ_felt(__warp_se_83);
                                
                                let (__warp_se_85) = WS3_INDEX_felt_to_warp_id(__warp_10_rightsOver, __warp_se_84);
                                
                                let (__warp_se_86) = WS0_READ_warp_id(__warp_se_85);
                                
                                let (__warp_se_87) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                                
                                let (__warp_se_88) = WS0_READ_warp_id(__warp_se_87);
                                
                                let (__warp_se_89) = WARP_DARRAY0_felt_IDX(__warp_se_88, __warp_33_j);
                                
                                let (__warp_se_90) = WS2_READ_felt(__warp_se_89);
                                
                                let (__warp_se_91) = WS3_INDEX_felt_to_warp_id(__warp_10_rightsOver, __warp_se_90);
                                
                                let (__warp_se_92) = WS0_READ_warp_id(__warp_se_91);
                                
                                let (__warp_se_93) = WARP_DARRAY1_Uint256_LENGTH.read(__warp_se_92);
                                
                                let (__warp_se_94) = warp_sub256(__warp_se_93, Uint256(low=1, high=0));
                                
                                let (__warp_se_95) = WARP_DARRAY1_Uint256_IDX(__warp_se_86, __warp_se_94);
                                
                                let (__warp_se_96) = WS1_READ_Uint256(__warp_se_95);
                                
                                WS_WRITE0(__warp_se_80, __warp_se_96);
                                
                                let (__warp_se_97) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
                                
                                let (__warp_se_98) = WS0_READ_warp_id(__warp_se_97);
                                
                                let (__warp_se_99) = WARP_DARRAY0_felt_IDX(__warp_se_98, __warp_33_j);
                                
                                let (__warp_se_100) = WS2_READ_felt(__warp_se_99);
                                
                                let (__warp_se_101) = WS3_INDEX_felt_to_warp_id(__warp_10_rightsOver, __warp_se_100);
                                
                                let (__warp_se_102) = WS0_READ_warp_id(__warp_se_101);
                                
                                WARP_DARRAY1_Uint256_POP(__warp_se_102);
                                
                                let __warp_38_i = __warp_38_i;
                                
                                let __warp_31__rightid = __warp_31__rightid;
                                
                                let __warp_33_j = __warp_33_j;
                                
                                
                                
                                return (__warp_38_i, __warp_31__rightid, __warp_33_j);
                        }else{
                        
                            
                            let (__warp_38_i, __warp_31__rightid, __warp_33_j) = __warp_while0_if_part2(__warp_38_i, __warp_31__rightid, __warp_33_j);
                            
                            
                            
                            return (__warp_38_i, __warp_31__rightid, __warp_33_j);
                        }
            }else{
            
                
                    
                    let __warp_38_i = __warp_38_i;
                    
                    let __warp_31__rightid = __warp_31__rightid;
                    
                    let __warp_33_j = __warp_33_j;
                    
                    
                    
                    return (__warp_38_i, __warp_31__rightid, __warp_33_j);
            }

    }


    func __warp_while0_if_part2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_38_i : Uint256, __warp_31__rightid : Uint256, __warp_33_j : Uint256)-> (__warp_38_i : Uint256, __warp_31__rightid : Uint256, __warp_33_j : Uint256){
    alloc_locals;


        
            
            
            
            let (__warp_pse_0) = warp_add256(__warp_38_i, Uint256(low=1, high=0));
            
            let __warp_38_i = __warp_pse_0;
            
            warp_sub256(__warp_pse_0, Uint256(low=1, high=0));
        
        let (__warp_38_i, __warp_31__rightid, __warp_33_j) = __warp_while0_if_part1(__warp_38_i, __warp_31__rightid, __warp_33_j);
        
        
        
        return (__warp_38_i, __warp_31__rightid, __warp_33_j);

    }


    func __warp_while0_if_part1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_38_i : Uint256, __warp_31__rightid : Uint256, __warp_33_j : Uint256)-> (__warp_38_i : Uint256, __warp_31__rightid : Uint256, __warp_33_j : Uint256){
    alloc_locals;


        
        
        
        let (__warp_38_i, __warp_31__rightid, __warp_33_j) = __warp_while0(__warp_38_i, __warp_31__rightid, __warp_33_j);
        
        
        
        return (__warp_38_i, __warp_31__rightid, __warp_33_j);

    }


    func __warp_modifier_isNFTOwner_setAvailability_e0beb8c0_11{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_18__rightid : Uint256, __warp_parameter___warp_44__rightid8 : Uint256, __warp_parameter___warp_45__available9 : felt, __warp_parameter___warp_46__nftindex10 : Uint256)-> (){
    alloc_locals;


        
        let (__warp_se_103) = WS4_INDEX_Uint256_to_felt(__warp_13_owner, __warp_18__rightid);
        
        let (__warp_se_104) = WS2_READ_felt(__warp_se_103);
        
        let (__warp_se_105) = get_caller_address();
        
        let (__warp_se_106) = warp_eq(__warp_se_104, __warp_se_105);
        
        with_attr error_message("only the NFT Owner"){
            assert __warp_se_106 = 1;
        }
        
        __warp_original_function_setAvailability_e0beb8c0_7(__warp_parameter___warp_44__rightid8, __warp_parameter___warp_45__available9, __warp_parameter___warp_46__nftindex10);
        
        
        
        return ();

    }


    func __warp_original_function_setAvailability_e0beb8c0_7{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_44__rightid : Uint256, __warp_45__available : felt, __warp_46__nftindex : Uint256)-> (){
    alloc_locals;


        
        let (__warp_se_107) = WS4_INDEX_Uint256_to_felt(__warp_12_isAvailable, __warp_44__rightid);
        
        let (__warp_se_108) = WS2_READ_felt(__warp_se_107);
        
        let (__warp_se_109) = warp_eq(__warp_se_108, 1);
        
        if (__warp_se_109 != 0){
        
            
                
                let (__warp_se_110) = WARP_DARRAY1_Uint256_IDX(__warp_3_availableRights, __warp_46__nftindex);
                
                let (__warp_se_111) = WS1_READ_Uint256(__warp_se_110);
                
                let (__warp_se_112) = warp_eq256(__warp_se_111, __warp_44__rightid);
                
                with_attr error_message("wrong index for rightid"){
                    assert __warp_se_112 = 1;
                }
            
            __warp_original_function_setAvailability_e0beb8c0_7_if_part1(__warp_45__available, __warp_46__nftindex, __warp_44__rightid);
            
            let __warp_uv5 = ();
            
            
            
            return ();
        }else{
        
            
            __warp_original_function_setAvailability_e0beb8c0_7_if_part1(__warp_45__available, __warp_46__nftindex, __warp_44__rightid);
            
            let __warp_uv6 = ();
            
            
            
            return ();
        }

    }


    func __warp_original_function_setAvailability_e0beb8c0_7_if_part1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_45__available : felt, __warp_46__nftindex : Uint256, __warp_44__rightid : Uint256)-> (){
    alloc_locals;


        
        let (__warp_se_113) = warp_eq(__warp_45__available, 0);
        
        if (__warp_se_113 != 0){
        
            
                
                let (__warp_se_114) = WARP_DARRAY1_Uint256_IDX(__warp_3_availableRights, __warp_46__nftindex);
                
                let (__warp_se_115) = WARP_DARRAY1_Uint256_LENGTH.read(__warp_3_availableRights);
                
                let (__warp_se_116) = warp_sub256(__warp_se_115, Uint256(low=1, high=0));
                
                let (__warp_se_117) = WARP_DARRAY1_Uint256_IDX(__warp_3_availableRights, __warp_se_116);
                
                let (__warp_se_118) = WS1_READ_Uint256(__warp_se_117);
                
                WS_WRITE0(__warp_se_114, __warp_se_118);
                
                WARP_DARRAY1_Uint256_POP(__warp_3_availableRights);
            
            __warp_original_function_setAvailability_e0beb8c0_7_if_part1_if_part1(__warp_44__rightid, __warp_45__available);
            
            let __warp_uv7 = ();
            
            
            
            return ();
        }else{
        
            
                
                WARP_DARRAY1_Uint256_PUSHV0(__warp_3_availableRights, __warp_44__rightid);
            
            __warp_original_function_setAvailability_e0beb8c0_7_if_part1_if_part1(__warp_44__rightid, __warp_45__available);
            
            let __warp_uv8 = ();
            
            
            
            return ();
        }

    }


    func __warp_original_function_setAvailability_e0beb8c0_7_if_part1_if_part1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_44__rightid : Uint256, __warp_45__available : felt)-> (){
    alloc_locals;


        
        let (__warp_se_119) = WS4_INDEX_Uint256_to_felt(__warp_12_isAvailable, __warp_44__rightid);
        
        WS_WRITE1(__warp_se_119, __warp_45__available);
        
        
        
        return ();

    }


    func __warp_modifier_isNFTOwner_withdrawNFT_3a0196af_6{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_18__rightid : Uint256, __warp_parameter___warp_39__rightid4 : Uint256, __warp_parameter___warp_40__rightIndex5 : Uint256)-> (){
    alloc_locals;


        
        let (__warp_se_120) = WS4_INDEX_Uint256_to_felt(__warp_13_owner, __warp_18__rightid);
        
        let (__warp_se_121) = WS2_READ_felt(__warp_se_120);
        
        let (__warp_se_122) = get_caller_address();
        
        let (__warp_se_123) = warp_eq(__warp_se_121, __warp_se_122);
        
        with_attr error_message("only the NFT Owner"){
            assert __warp_se_123 = 1;
        }
        
        __warp_original_function_withdrawNFT_3a0196af_3(__warp_parameter___warp_39__rightid4, __warp_parameter___warp_40__rightIndex5);
        
        
        
        return ();

    }


    func __warp_original_function_withdrawNFT_3a0196af_3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_39__rightid : Uint256, __warp_40__rightIndex : Uint256)-> (){
    alloc_locals;


        
        let (__warp_se_124) = WS2_INDEX_Uint256_to_Uint256(__warp_4_highestDeadline, __warp_39__rightid);
        
        let (__warp_se_125) = WS1_READ_Uint256(__warp_se_124);
        
        let (__warp_se_126) = warp_block_timestamp();
        
        let (__warp_se_127) = warp_lt256(__warp_se_125, __warp_se_126);
        
        with_attr error_message("highest right deadline should end before withdraw"){
            assert __warp_se_127 = 1;
        }
        
        let (__warp_se_128) = WS4_INDEX_Uint256_to_felt(__warp_12_isAvailable, __warp_39__rightid);
        
        let (__warp_se_129) = WS2_READ_felt(__warp_se_128);
        
        let (__warp_se_130) = warp_eq(__warp_se_129, 0);
        
        with_attr error_message("NFT should be unavailable"){
            assert __warp_se_130 = 1;
        }
        
        let (__warp_se_131) = get_caller_address();
        
        let (__warp_se_132) = WS3_INDEX_felt_to_warp_id(__warp_11_properties, __warp_se_131);
        
        let (__warp_se_133) = WS0_READ_warp_id(__warp_se_132);
        
        let (__warp_se_134) = WARP_DARRAY1_Uint256_IDX(__warp_se_133, __warp_40__rightIndex);
        
        let (__warp_se_135) = WS1_READ_Uint256(__warp_se_134);
        
        let (__warp_se_136) = warp_eq256(__warp_se_135, __warp_39__rightid);
        
        with_attr error_message("wrong index for collection address"){
            assert __warp_se_136 = 1;
        }
        
        let (__warp_se_137) = WS0_INDEX_Uint256_to_warp_id(__warp_5_rightsOrigin, __warp_39__rightid);
        
        let (__warp_se_138) = WS0_READ_warp_id(__warp_se_137);
        
        let (__warp_se_139) = WARP_DARRAY1_Uint256_IDX(__warp_se_138, Uint256(low=0, high=0));
        
        let (__warp_se_140) = WS1_READ_Uint256(__warp_se_139);
        
        let (__warp_41_erc721) = uint256_to_address_felt(__warp_se_140);
        
        let (__warp_se_141) = WS0_INDEX_Uint256_to_warp_id(__warp_5_rightsOrigin, __warp_39__rightid);
        
        let (__warp_se_142) = WS0_READ_warp_id(__warp_se_141);
        
        let (__warp_se_143) = WARP_DARRAY1_Uint256_IDX(__warp_se_142, Uint256(low=1, high=0));
        
        let (__warp_42_nftid) = WS1_READ_Uint256(__warp_se_143);
        
        _burn_cee630ae(__warp_39__rightid, __warp_40__rightIndex);
        
        let (__warp_se_144) = WS2_INDEX_Uint256_to_Uint256(__warp_4_highestDeadline, __warp_39__rightid);
        
        WS_WRITE0(__warp_se_144, Uint256(low=0, high=0));
        
        let __warp_43_e721 = __warp_41_erc721;
        
        let (__warp_se_145) = get_contract_address();
        
        let (__warp_se_146) = get_caller_address();
        
        IERC721_warped_interface.transferFrom_23b872dd(__warp_43_e721, __warp_se_145, __warp_se_146, __warp_42_nftid);
        
        
        
        return ();

    }


    func __warp_modifier_isNFTOwner_withdrawRoyalties_5daa02ed_2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_18__rightid : Uint256, __warp_parameter___warp_31__rightid1 : Uint256)-> (){
    alloc_locals;


        
        let (__warp_se_147) = WS4_INDEX_Uint256_to_felt(__warp_13_owner, __warp_18__rightid);
        
        let (__warp_se_148) = WS2_READ_felt(__warp_se_147);
        
        let (__warp_se_149) = get_caller_address();
        
        let (__warp_se_150) = warp_eq(__warp_se_148, __warp_se_149);
        
        with_attr error_message("only the NFT Owner"){
            assert __warp_se_150 = 1;
        }
        
        __warp_original_function_withdrawRoyalties_5daa02ed_0(__warp_parameter___warp_31__rightid1);
        
        
        
        return ();

    }


    func __warp_original_function_withdrawRoyalties_5daa02ed_0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_31__rightid : Uint256)-> (){
    alloc_locals;


        
        let (__warp_se_151) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_31__rightid);
        
        let (__warp_se_152) = WS0_READ_warp_id(__warp_se_151);
        
        let (__warp_se_153) = WARP_DARRAY0_felt_LENGTH.read(__warp_se_152);
        
        let (__warp_se_154) = warp_gt256(__warp_se_153, Uint256(low=0, high=0));
        
        with_attr error_message("right does not exists"){
            assert __warp_se_154 = 1;
        }
        
        let __warp_32_amountToWithdraw = Uint256(low=0, high=0);
        
        let __warp_33_j = Uint256(low=0, high=0);
        
        let (__warp_34_ct) = WS2_READ_felt(__warp_1_governanceToken);
        
            
            let (__warp_tv_3, __warp_tv_4, __warp_tv_5) = __warp_while1(__warp_31__rightid, __warp_33_j, __warp_32_amountToWithdraw);
            
            let __warp_32_amountToWithdraw = __warp_tv_5;
            
            let __warp_33_j = __warp_tv_4;
            
            let __warp_31__rightid = __warp_tv_3;
        
        let (__warp_se_155) = get_caller_address();
        
        _emit_RoyaltiesWithdraw_644800e6(__warp_se_155, __warp_32_amountToWithdraw);
        
        let (__warp_se_156) = get_caller_address();
        
        Token_warped_interface.transfer_a9059cbb(__warp_34_ct, __warp_se_156, __warp_32_amountToWithdraw);
        
        
        
        return ();

    }


    func __warp_constructor_0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_19__owner : felt)-> (){
    alloc_locals;


        
        WS_WRITE1(__warp_2_contractOwner, __warp_19__owner);
        
        
        
        return ();

    }


    func getRights_1d3ae1b2_if_part1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_20__rightid : Uint256, __warp_21__period : Uint256)-> (){
    alloc_locals;


        
        let (__warp_se_206) = WS0_INDEX_Uint256_to_warp_id(__warp_14_rightHolders, __warp_20__rightid);
        
        let (__warp_se_207) = WS0_READ_warp_id(__warp_se_206);
        
        let (__warp_se_208) = get_caller_address();
        
        WARP_DARRAY0_felt_PUSHV1(__warp_se_207, __warp_se_208);
        
        let (__warp_se_209) = get_caller_address();
        
        _emit_GetRight_4215fdfe(__warp_20__rightid, __warp_21__period, __warp_se_209);
        
        
        
        return ();

    }


    func _mint_7da6196d{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*, keccak_ptr : felt*}(__warp_53__erc721 : felt, __warp_54__nftid : Uint256, __warp_55__amount : Uint256, __warp_56__dailyPrice : Uint256, __warp_57__maxPeriod : Uint256, __warp_58__nftUri : felt)-> (){
    alloc_locals;


        
        let (__warp_se_255) = abi_encode0(__warp_53__erc721, __warp_54__nftid);
        
        let (__warp_59_rightid) = warp_keccak(__warp_se_255);
        
        let (__warp_se_256) = WS2_INDEX_Uint256_to_Uint256(__warp_8_maxRightsHolders, __warp_59_rightid);
        
        WS_WRITE0(__warp_se_256, __warp_55__amount);
        
        let (__warp_se_257) = WS2_INDEX_Uint256_to_Uint256(__warp_7_dailyPrice, __warp_59_rightid);
        
        WS_WRITE0(__warp_se_257, __warp_56__dailyPrice);
        
        let (__warp_se_258) = WS2_INDEX_Uint256_to_Uint256(__warp_9_maxtime, __warp_59_rightid);
        
        WS_WRITE0(__warp_se_258, __warp_57__maxPeriod);
        
        let (__warp_se_259) = WS4_INDEX_Uint256_to_felt(__warp_13_owner, __warp_59_rightid);
        
        let (__warp_se_260) = get_caller_address();
        
        WS_WRITE1(__warp_se_259, __warp_se_260);
        
        let (__warp_se_261) = WS0_INDEX_Uint256_to_warp_id(__warp_5_rightsOrigin, __warp_59_rightid);
        
        let (__warp_se_262) = WS0_READ_warp_id(__warp_se_261);
        
        let (__warp_se_263) = felt_to_uint256(__warp_53__erc721);
        
        WARP_DARRAY1_Uint256_PUSHV2(__warp_se_262, __warp_se_263);
        
        let (__warp_se_264) = WS0_INDEX_Uint256_to_warp_id(__warp_5_rightsOrigin, __warp_59_rightid);
        
        let (__warp_se_265) = WS0_READ_warp_id(__warp_se_264);
        
        WARP_DARRAY1_Uint256_PUSHV2(__warp_se_265, __warp_54__nftid);
        
        let (__warp_se_266) = WS0_INDEX_Uint256_to_warp_id(__warp_6_rightUri, __warp_59_rightid);
        
        let (__warp_se_267) = WS0_READ_warp_id(__warp_se_266);
        
        wm_to_storage0(__warp_se_267, __warp_58__nftUri);
        
        let (__warp_se_268) = WS4_INDEX_Uint256_to_felt(__warp_12_isAvailable, __warp_59_rightid);
        
        WS_WRITE1(__warp_se_268, 1);
        
        let (__warp_se_269) = get_caller_address();
        
        let (__warp_se_270) = WS3_INDEX_felt_to_warp_id(__warp_11_properties, __warp_se_269);
        
        let (__warp_se_271) = WS0_READ_warp_id(__warp_se_270);
        
        WARP_DARRAY1_Uint256_PUSHV0(__warp_se_271, __warp_59_rightid);
        
        WARP_DARRAY1_Uint256_PUSHV0(__warp_3_availableRights, __warp_59_rightid);
        
        
        
        return ();

    }


    func _burn_cee630ae{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}(__warp_60__rightid : Uint256, __warp_61__rightIndex : Uint256)-> (){
    alloc_locals;


        
        let (__warp_se_272) = WS2_INDEX_Uint256_to_Uint256(__warp_8_maxRightsHolders, __warp_60__rightid);
        
        WS_WRITE0(__warp_se_272, Uint256(low=0, high=0));
        
        let (__warp_se_273) = WS2_INDEX_Uint256_to_Uint256(__warp_7_dailyPrice, __warp_60__rightid);
        
        WS_WRITE0(__warp_se_273, Uint256(low=0, high=0));
        
        let (__warp_se_274) = WS2_INDEX_Uint256_to_Uint256(__warp_9_maxtime, __warp_60__rightid);
        
        WS_WRITE0(__warp_se_274, Uint256(low=0, high=0));
        
        let (__warp_se_275) = WS0_INDEX_Uint256_to_warp_id(__warp_5_rightsOrigin, __warp_60__rightid);
        
        let (__warp_se_276) = WS0_READ_warp_id(__warp_se_275);
        
        WARP_DARRAY1_Uint256_POP(__warp_se_276);
        
        let (__warp_se_277) = WS0_INDEX_Uint256_to_warp_id(__warp_5_rightsOrigin, __warp_60__rightid);
        
        let (__warp_se_278) = WS0_READ_warp_id(__warp_se_277);
        
        WARP_DARRAY1_Uint256_POP(__warp_se_278);
        
        let (__warp_se_279) = get_caller_address();
        
        let (__warp_se_280) = WS3_INDEX_felt_to_warp_id(__warp_11_properties, __warp_se_279);
        
        let (__warp_se_281) = WS0_READ_warp_id(__warp_se_280);
        
        let (__warp_se_282) = WARP_DARRAY1_Uint256_IDX(__warp_se_281, __warp_61__rightIndex);
        
        let (__warp_se_283) = get_caller_address();
        
        let (__warp_se_284) = WS3_INDEX_felt_to_warp_id(__warp_11_properties, __warp_se_283);
        
        let (__warp_se_285) = WS0_READ_warp_id(__warp_se_284);
        
        let (__warp_se_286) = get_caller_address();
        
        let (__warp_se_287) = WS3_INDEX_felt_to_warp_id(__warp_11_properties, __warp_se_286);
        
        let (__warp_se_288) = WS0_READ_warp_id(__warp_se_287);
        
        let (__warp_se_289) = WARP_DARRAY1_Uint256_LENGTH.read(__warp_se_288);
        
        let (__warp_se_290) = warp_sub256(__warp_se_289, Uint256(low=1, high=0));
        
        let (__warp_se_291) = WARP_DARRAY1_Uint256_IDX(__warp_se_285, __warp_se_290);
        
        let (__warp_se_292) = WS1_READ_Uint256(__warp_se_291);
        
        WS_WRITE0(__warp_se_282, __warp_se_292);
        
        let (__warp_se_293) = get_caller_address();
        
        let (__warp_se_294) = WS3_INDEX_felt_to_warp_id(__warp_11_properties, __warp_se_293);
        
        let (__warp_se_295) = WS0_READ_warp_id(__warp_se_294);
        
        WARP_DARRAY1_Uint256_POP(__warp_se_295);
        
        let (__warp_se_296) = WS0_INDEX_Uint256_to_warp_id(__warp_6_rightUri, __warp_60__rightid);
        
        let (__warp_se_297) = WS0_READ_warp_id(__warp_se_296);
        
        let (__warp_se_298) = WM0_d_arr();
        
        wm_to_storage0(__warp_se_297, __warp_se_298);
        
        let (__warp_se_299) = WS4_INDEX_Uint256_to_felt(__warp_13_owner, __warp_60__rightid);
        
        WS_WRITE1(__warp_se_299, 0);
        
        
        
        return ();

    }

}


    @external
    func getRights_1d3ae1b2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_20__rightid : Uint256, __warp_21__period : Uint256)-> (){
    alloc_locals;
    let (local keccak_ptr_start : felt*) = alloc();
    let keccak_ptr = keccak_ptr_start;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory, keccak_ptr{

        
        warp_external_input_check_int256(__warp_21__period);
        
        warp_external_input_check_int256(__warp_20__rightid);
        
        let (__warp_se_157) = WS4_INDEX_Uint256_to_felt(Canary.__warp_12_isAvailable, __warp_20__rightid);
        
        let (__warp_se_158) = WS2_READ_felt(__warp_se_157);
        
        with_attr error_message("NFT is not available"){
            assert __warp_se_158 = 1;
        }
        
        let (__warp_se_159) = WS2_INDEX_Uint256_to_Uint256(Canary.__warp_9_maxtime, __warp_20__rightid);
        
        let (__warp_se_160) = WS1_READ_Uint256(__warp_se_159);
        
        let (__warp_se_161) = warp_ge256(__warp_se_160, __warp_21__period);
        
        with_attr error_message("period is above the max period"){
            assert __warp_se_161 = 1;
        }
        
        let (__warp_se_162) = WS2_INDEX_Uint256_to_Uint256(Canary.__warp_8_maxRightsHolders, __warp_20__rightid);
        
        let (__warp_se_163) = WS1_READ_Uint256(__warp_se_162);
        
        let (__warp_se_164) = warp_gt256(__warp_se_163, Uint256(low=0, high=0));
        
        with_attr error_message("limit of right holders reached"){
            assert __warp_se_164 = 1;
        }
        
        let (__warp_se_165) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_16_rightsPeriod, __warp_20__rightid);
        
        let (__warp_se_166) = WS0_READ_warp_id(__warp_se_165);
        
        let (__warp_se_167) = get_caller_address();
        
        let (__warp_se_168) = WS1_INDEX_felt_to_Uint256(__warp_se_166, __warp_se_167);
        
        let (__warp_se_169) = WS1_READ_Uint256(__warp_se_168);
        
        let (__warp_se_170) = warp_eq256(__warp_se_169, Uint256(low=0, high=0));
        
        with_attr error_message("already buy this right"){
            assert __warp_se_170 = 1;
        }
        
        let (__warp_se_171) = warp_gt256(__warp_21__period, Uint256(low=0, high=0));
        
        with_attr error_message("period is equal to 0"){
            assert __warp_se_171 = 1;
        }
        
        let (__warp_se_172) = WS2_INDEX_Uint256_to_Uint256(Canary.__warp_8_maxRightsHolders, __warp_20__rightid);
        
        let (__warp_se_173) = WS2_INDEX_Uint256_to_Uint256(Canary.__warp_8_maxRightsHolders, __warp_20__rightid);
        
        let (__warp_se_174) = WS1_READ_Uint256(__warp_se_173);
        
        let (__warp_se_175) = warp_sub256(__warp_se_174, Uint256(low=1, high=0));
        
        WS_WRITE0(__warp_se_172, __warp_se_175);
        
        let (__warp_se_176) = WS2_INDEX_Uint256_to_Uint256(Canary.__warp_7_dailyPrice, __warp_20__rightid);
        
        let (__warp_se_177) = WS1_READ_Uint256(__warp_se_176);
        
        let (__warp_22_value) = warp_mul256(__warp_se_177, __warp_21__period);
        
        let (__warp_se_178) = WS1_READ_Uint256(Canary.__warp_0_treasury);
        
        let (__warp_se_179) = warp_mul256(__warp_22_value, Uint256(low=500, high=0));
        
        let (__warp_se_180) = warp_div256(__warp_se_179, Uint256(low=10000, high=0));
        
        let (__warp_se_181) = warp_add256(__warp_se_178, __warp_se_180);
        
        WS_WRITE0(Canary.__warp_0_treasury, __warp_se_181);
        
        let (__warp_se_182) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_16_rightsPeriod, __warp_20__rightid);
        
        let (__warp_se_183) = WS0_READ_warp_id(__warp_se_182);
        
        let (__warp_se_184) = get_caller_address();
        
        let (__warp_se_185) = WS1_INDEX_felt_to_Uint256(__warp_se_183, __warp_se_184);
        
        WS_WRITE0(__warp_se_185, __warp_21__period);
        
        let (__warp_se_186) = get_caller_address();
        
        let (__warp_se_187) = WS3_INDEX_felt_to_warp_id(Canary.__warp_10_rightsOver, __warp_se_186);
        
        let (__warp_se_188) = WS0_READ_warp_id(__warp_se_187);
        
        WARP_DARRAY1_Uint256_PUSHV0(__warp_se_188, __warp_20__rightid);
        
        let (__warp_se_189) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_15_deadline, __warp_20__rightid);
        
        let (__warp_se_190) = WS0_READ_warp_id(__warp_se_189);
        
        let (__warp_se_191) = get_caller_address();
        
        let (__warp_se_192) = WS1_INDEX_felt_to_Uint256(__warp_se_190, __warp_se_191);
        
        let (__warp_se_193) = warp_block_timestamp();
        
        let (__warp_se_194) = warp_mul256(Uint256(low=86400, high=0), __warp_21__period);
        
        let (__warp_se_195) = warp_add256(__warp_se_193, __warp_se_194);
        
        WS_WRITE0(__warp_se_192, __warp_se_195);
        
        let (__warp_se_196) = warp_block_timestamp();
        
        let (__warp_se_197) = warp_mul256(Uint256(low=86400, high=0), __warp_21__period);
        
        let (__warp_se_198) = warp_add256(__warp_se_196, __warp_se_197);
        
        let (__warp_se_199) = WS2_INDEX_Uint256_to_Uint256(Canary.__warp_4_highestDeadline, __warp_20__rightid);
        
        let (__warp_se_200) = WS1_READ_Uint256(__warp_se_199);
        
        let (__warp_se_201) = warp_gt256(__warp_se_198, __warp_se_200);
        
        if (__warp_se_201 != 0){
        
            
                
                let (__warp_se_202) = WS2_INDEX_Uint256_to_Uint256(Canary.__warp_4_highestDeadline, __warp_20__rightid);
                
                let (__warp_se_203) = warp_block_timestamp();
                
                let (__warp_se_204) = warp_mul256(Uint256(low=86400, high=0), __warp_21__period);
                
                let (__warp_se_205) = warp_add256(__warp_se_203, __warp_se_204);
                
                WS_WRITE0(__warp_se_202, __warp_se_205);
            
            Canary.getRights_1d3ae1b2_if_part1(__warp_20__rightid, __warp_21__period);
            
            let __warp_uv0 = ();
            
            default_dict_finalize(warp_memory_start, warp_memory, 0);
            
            finalize_keccak(keccak_ptr_start, keccak_ptr);
            
            return ();
        }else{
        
            
            Canary.getRights_1d3ae1b2_if_part1(__warp_20__rightid, __warp_21__period);
            
            let __warp_uv1 = ();
            
            default_dict_finalize(warp_memory_start, warp_memory, 0);
            
            finalize_keccak(keccak_ptr_start, keccak_ptr);
            
            return ();
        }
    }
    }


    @external
    func depositNFT_d21d34f4{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_23__erc721 : felt, __warp_24__nftid : Uint256, __warp_25__dailyPrice : Uint256, __warp_26__maxPeriod : Uint256, __warp_27__amount : Uint256)-> (){
    alloc_locals;
    let (local keccak_ptr_start : felt*) = alloc();
    let keccak_ptr = keccak_ptr_start;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory, keccak_ptr{

        
        warp_external_input_check_int256(__warp_27__amount);
        
        warp_external_input_check_int256(__warp_26__maxPeriod);
        
        warp_external_input_check_int256(__warp_25__dailyPrice);
        
        warp_external_input_check_int256(__warp_24__nftid);
        
        warp_external_input_check_address(__warp_23__erc721);
        
        let (__warp_se_210) = warp_neq(__warp_23__erc721, 0);
        
        with_attr error_message("collection address is zero"){
            assert __warp_se_210 = 1;
        }
        
        let __warp_28_e721metadata = __warp_23__erc721;
        
        let (__warp_29_uri_cd_raw_len, __warp_29_uri_cd_raw) = ERC721Metadata_warped_interface.tokenURI_c87b56dd(__warp_28_e721metadata, __warp_24__nftid);
        
        local __warp_29_uri_cd : cd_dynarray_felt = cd_dynarray_felt(__warp_29_uri_cd_raw_len, __warp_29_uri_cd_raw);
        
        let (__warp_29_uri) = cd_to_memory0(__warp_29_uri_cd);
        
        Canary._mint_7da6196d(__warp_23__erc721, __warp_24__nftid, __warp_27__amount, __warp_25__dailyPrice, __warp_26__maxPeriod, __warp_29_uri);
        
        let __warp_30_e721 = __warp_23__erc721;
        
        let (__warp_se_211) = get_caller_address();
        
        let (__warp_se_212) = get_contract_address();
        
        IERC721_warped_interface.transferFrom_23b872dd(__warp_30_e721, __warp_se_211, __warp_se_212, __warp_24__nftid);
        
        _emit_DepositedNFT_8b187cf9(__warp_23__erc721, __warp_24__nftid);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        finalize_keccak(keccak_ptr_start, keccak_ptr);
        
        return ();
    }
    }


    @external
    func withdrawRoyalties_5daa02ed{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_31__rightid : Uint256)-> (){
    alloc_locals;
    let (local keccak_ptr_start : felt*) = alloc();
    let keccak_ptr = keccak_ptr_start;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory, keccak_ptr{

        
        warp_external_input_check_int256(__warp_31__rightid);
        
        Canary.__warp_modifier_isNFTOwner_withdrawRoyalties_5daa02ed_2(__warp_31__rightid, __warp_31__rightid);
        
        let __warp_uv2 = ();
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        finalize_keccak(keccak_ptr_start, keccak_ptr);
        
        return ();
    }
    }


    @external
    func withdrawNFT_3a0196af{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_39__rightid : Uint256, __warp_40__rightIndex : Uint256)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int256(__warp_40__rightIndex);
        
        warp_external_input_check_int256(__warp_39__rightid);
        
        Canary.__warp_modifier_isNFTOwner_withdrawNFT_3a0196af_6(__warp_39__rightid, __warp_39__rightid, __warp_40__rightIndex);
        
        let __warp_uv3 = ();
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func setAvailability_e0beb8c0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_44__rightid : Uint256, __warp_45__available : felt, __warp_46__nftindex : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_46__nftindex);
        
        warp_external_input_check_bool(__warp_45__available);
        
        warp_external_input_check_int256(__warp_44__rightid);
        
        Canary.__warp_modifier_isNFTOwner_setAvailability_e0beb8c0_11(__warp_44__rightid, __warp_44__rightid, __warp_45__available, __warp_46__nftindex);
        
        let __warp_uv4 = ();
        
        
        
        return ();

    }


    @external
    func verifyRight_088ce803{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_47__rightid : Uint256, __warp_48__platform : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_address(__warp_48__platform);
        
        warp_external_input_check_int256(__warp_47__rightid);
        
        let (__warp_se_213) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_16_rightsPeriod, __warp_47__rightid);
        
        let (__warp_se_214) = WS0_READ_warp_id(__warp_se_213);
        
        let (__warp_se_215) = WS1_INDEX_felt_to_Uint256(__warp_se_214, __warp_48__platform);
        
        let (__warp_se_216) = WS1_READ_Uint256(__warp_se_215);
        
        let (__warp_se_217) = warp_eq256(__warp_se_216, Uint256(low=0, high=0));
        
        with_attr error_message("the platform cannot be the right holder"){
            assert __warp_se_217 = 1;
        }
        
        let (__warp_se_218) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_16_rightsPeriod, __warp_47__rightid);
        
        let (__warp_se_219) = WS0_READ_warp_id(__warp_se_218);
        
        let (__warp_se_220) = get_caller_address();
        
        let (__warp_se_221) = WS1_INDEX_felt_to_Uint256(__warp_se_219, __warp_se_220);
        
        let (__warp_se_222) = WS1_READ_Uint256(__warp_se_221);
        
        let (__warp_se_223) = warp_gt256(__warp_se_222, Uint256(low=0, high=0));
        
        with_attr error_message("sender is not the right holder"){
            assert __warp_se_223 = 1;
        }
        
        let (__warp_se_224) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_15_deadline, __warp_47__rightid);
        
        let (__warp_se_225) = WS0_READ_warp_id(__warp_se_224);
        
        let (__warp_se_226) = get_caller_address();
        
        let (__warp_se_227) = WS1_INDEX_felt_to_Uint256(__warp_se_225, __warp_se_226);
        
        let (__warp_se_228) = WS1_READ_Uint256(__warp_se_227);
        
        let (__warp_se_229) = warp_block_timestamp();
        
        let (__warp_se_230) = warp_gt256(__warp_se_228, __warp_se_229);
        
        with_attr error_message("has exceeded the right time"){
            assert __warp_se_230 = 1;
        }
        
        let (__warp_se_231) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_17_validated, __warp_47__rightid);
        
        let (__warp_se_232) = WS0_READ_warp_id(__warp_se_231);
        
        let (__warp_se_233) = WS3_INDEX_felt_to_warp_id(__warp_se_232, __warp_48__platform);
        
        let (__warp_se_234) = WS0_READ_warp_id(__warp_se_233);
        
        let (__warp_se_235) = get_caller_address();
        
        let (__warp_se_236) = WS5_INDEX_felt_to_felt(__warp_se_234, __warp_se_235);
        
        let (__warp_se_237) = WS2_READ_felt(__warp_se_236);
        
        let (__warp_se_238) = warp_eq(__warp_se_237, 0);
        
        with_attr error_message("rightid and right holder are already validated"){
            assert __warp_se_238 = 1;
        }
        
        let (__warp_se_239) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_17_validated, __warp_47__rightid);
        
        let (__warp_se_240) = WS0_READ_warp_id(__warp_se_239);
        
        let (__warp_se_241) = WS3_INDEX_felt_to_warp_id(__warp_se_240, __warp_48__platform);
        
        let (__warp_se_242) = WS0_READ_warp_id(__warp_se_241);
        
        let (__warp_se_243) = get_caller_address();
        
        let (__warp_se_244) = WS5_INDEX_felt_to_felt(__warp_se_242, __warp_se_243);
        
        WS_WRITE1(__warp_se_244, 1);
        
        let (__warp_49_ct) = WS2_READ_felt(Canary.__warp_1_governanceToken);
        
        let (__warp_se_245) = WS2_INDEX_Uint256_to_Uint256(Canary.__warp_7_dailyPrice, __warp_47__rightid);
        
        let (__warp_se_246) = WS1_READ_Uint256(__warp_se_245);
        
        let (__warp_se_247) = warp_div256(__warp_se_246, Uint256(low=2, high=0));
        
        Token_warped_interface.mint_40c10f19(__warp_49_ct, __warp_48__platform, __warp_se_247);
        
        
        
        return ();

    }


    @view
    func verified_24d73567{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_50__rightid : Uint256, __warp_51__platform : felt)-> (__warp_52 : felt){
    alloc_locals;


        
        warp_external_input_check_address(__warp_51__platform);
        
        warp_external_input_check_int256(__warp_50__rightid);
        
        let (__warp_se_248) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_17_validated, __warp_50__rightid);
        
        let (__warp_se_249) = WS0_READ_warp_id(__warp_se_248);
        
        let (__warp_se_250) = WS3_INDEX_felt_to_warp_id(__warp_se_249, __warp_51__platform);
        
        let (__warp_se_251) = WS0_READ_warp_id(__warp_se_250);
        
        let (__warp_se_252) = get_caller_address();
        
        let (__warp_se_253) = WS5_INDEX_felt_to_felt(__warp_se_251, __warp_se_252);
        
        let (__warp_se_254) = WS2_READ_felt(__warp_se_253);
        
        
        
        return (__warp_se_254,);

    }


    @external
    func setGovernanceToken_f8570170{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_62__newToken : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_address(__warp_62__newToken);
        
        let (__warp_se_300) = WS2_READ_felt(Canary.__warp_2_contractOwner);
        
        let (__warp_se_301) = get_caller_address();
        
        let (__warp_se_302) = warp_eq(__warp_se_300, __warp_se_301);
        
        assert __warp_se_302 = 1;
        
        WS_WRITE1(Canary.__warp_1_governanceToken, __warp_62__newToken);
        
        
        
        return ();

    }


    @view
    func currentTreasury_0f265bdd{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_63 : Uint256){
    alloc_locals;


        
        let (__warp_se_303) = WS1_READ_Uint256(Canary.__warp_0_treasury);
        
        
        
        return (__warp_se_303,);

    }


    @view
    func dailyPriceOf_ba987777{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_64__rightid : Uint256)-> (__warp_65 : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_64__rightid);
        
        let (__warp_se_304) = WS2_INDEX_Uint256_to_Uint256(Canary.__warp_7_dailyPrice, __warp_64__rightid);
        
        let (__warp_se_305) = WS1_READ_Uint256(__warp_se_304);
        
        
        
        return (__warp_se_305,);

    }


    @view
    func availableRightsOf_4394dd76{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_66__rightid : Uint256)-> (__warp_67 : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_66__rightid);
        
        let (__warp_se_306) = WS2_INDEX_Uint256_to_Uint256(Canary.__warp_8_maxRightsHolders, __warp_66__rightid);
        
        let (__warp_se_307) = WS1_READ_Uint256(__warp_se_306);
        
        
        
        return (__warp_se_307,);

    }


    @view
    func maxPeriodOf_26e07ef6{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_68__rightid : Uint256)-> (__warp_69 : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_68__rightid);
        
        let (__warp_se_308) = WS2_INDEX_Uint256_to_Uint256(Canary.__warp_9_maxtime, __warp_68__rightid);
        
        let (__warp_se_309) = WS1_READ_Uint256(__warp_se_308);
        
        
        
        return (__warp_se_309,);

    }


    @view
    func rightsPeriodOf_ef3776d7{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_70__rightid : Uint256, __warp_71__holder : felt)-> (__warp_72 : Uint256){
    alloc_locals;


        
        warp_external_input_check_address(__warp_71__holder);
        
        warp_external_input_check_int256(__warp_70__rightid);
        
        let (__warp_se_310) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_16_rightsPeriod, __warp_70__rightid);
        
        let (__warp_se_311) = WS0_READ_warp_id(__warp_se_310);
        
        let (__warp_se_312) = WS1_INDEX_felt_to_Uint256(__warp_se_311, __warp_71__holder);
        
        let (__warp_se_313) = WS1_READ_Uint256(__warp_se_312);
        
        
        
        return (__warp_se_313,);

    }


    @view
    func rightsOf_9a9a4f46{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_73__rightsHolder : felt)-> (__warp_74_len : felt, __warp_74 : Uint256*){
    alloc_locals;


        
        warp_external_input_check_address(__warp_73__rightsHolder);
        
        let (__warp_se_314) = WS3_INDEX_felt_to_warp_id(Canary.__warp_10_rightsOver, __warp_73__rightsHolder);
        
        let (__warp_se_315) = WS0_READ_warp_id(__warp_se_314);
        
        let (__warp_se_316) = ws_dynamic_array_to_calldata0(__warp_se_315);
        
        
        
        return (__warp_se_316.len, __warp_se_316.ptr,);

    }


    @view
    func propertiesOf_c7c314e0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_75__owner : felt)-> (__warp_76_len : felt, __warp_76 : Uint256*){
    alloc_locals;


        
        warp_external_input_check_address(__warp_75__owner);
        
        let (__warp_se_317) = WS3_INDEX_felt_to_warp_id(Canary.__warp_11_properties, __warp_75__owner);
        
        let (__warp_se_318) = WS0_READ_warp_id(__warp_se_317);
        
        let (__warp_se_319) = ws_dynamic_array_to_calldata0(__warp_se_318);
        
        
        
        return (__warp_se_319.len, __warp_se_319.ptr,);

    }


    @view
    func getAvailableNFTs_32702c95{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_77_len : felt, __warp_77 : Uint256*){
    alloc_locals;


        
        let (__warp_se_320) = ws_dynamic_array_to_calldata0(Canary.__warp_3_availableRights);
        
        
        
        return (__warp_se_320.len, __warp_se_320.ptr,);

    }


    @view
    func rightHoldersOf_e18138d7{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_78__rightid : Uint256)-> (__warp_79_len : felt, __warp_79 : felt*){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_78__rightid);
        
        let (__warp_se_321) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_14_rightHolders, __warp_78__rightid);
        
        let (__warp_se_322) = WS0_READ_warp_id(__warp_se_321);
        
        let (__warp_se_323) = ws_dynamic_array_to_calldata1(__warp_se_322);
        
        
        
        return (__warp_se_323.len, __warp_se_323.ptr,);

    }


    @view
    func holderDeadline_5e4df22c{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_80__rightid : Uint256, __warp_81__holder : felt)-> (__warp_82 : Uint256){
    alloc_locals;


        
        warp_external_input_check_address(__warp_81__holder);
        
        warp_external_input_check_int256(__warp_80__rightid);
        
        let (__warp_se_324) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_15_deadline, __warp_80__rightid);
        
        let (__warp_se_325) = WS0_READ_warp_id(__warp_se_324);
        
        let (__warp_se_326) = WS1_INDEX_felt_to_Uint256(__warp_se_325, __warp_81__holder);
        
        let (__warp_se_327) = WS1_READ_Uint256(__warp_se_326);
        
        
        
        return (__warp_se_327,);

    }


    @view
    func ownerOf_6352211e{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_83__rightid : Uint256)-> (__warp_84 : felt){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_83__rightid);
        
        let (__warp_se_328) = WS4_INDEX_Uint256_to_felt(Canary.__warp_13_owner, __warp_83__rightid);
        
        let (__warp_se_329) = WS2_READ_felt(__warp_se_328);
        
        
        
        return (__warp_se_329,);

    }


    @view
    func availabilityOf_9fe8b786{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_85__rightid : Uint256)-> (__warp_86 : felt){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_85__rightid);
        
        let (__warp_se_330) = WS4_INDEX_Uint256_to_felt(Canary.__warp_12_isAvailable, __warp_85__rightid);
        
        let (__warp_se_331) = WS2_READ_felt(__warp_se_330);
        
        
        
        return (__warp_se_331,);

    }


    @view
    func rightURI_e6be6db1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_87__rightid : Uint256)-> (__warp_88_len : felt, __warp_88 : felt*){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_87__rightid);
        
        let (__warp_se_332) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_6_rightUri, __warp_87__rightid);
        
        let (__warp_se_333) = WS0_READ_warp_id(__warp_se_332);
        
        let (__warp_se_334) = ws_dynamic_array_to_calldata2(__warp_se_333);
        
        
        
        return (__warp_se_334.len, __warp_se_334.ptr,);

    }


    @view
    func originOf_794b2a07{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_89__rightid : Uint256)-> (__warp_90_len : felt, __warp_90 : Uint256*){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_89__rightid);
        
        let (__warp_se_335) = WS0_INDEX_Uint256_to_warp_id(Canary.__warp_5_rightsOrigin, __warp_89__rightid);
        
        let (__warp_se_336) = WS0_READ_warp_id(__warp_se_335);
        
        let (__warp_se_337) = ws_dynamic_array_to_calldata3(__warp_se_336);
        
        
        
        return (__warp_se_337.len, __warp_se_337.ptr,);

    }


    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_19__owner : felt){
    alloc_locals;
    WARP_USED_STORAGE.write(23);
    WARP_NAMEGEN.write(17);


        
        warp_external_input_check_address(__warp_19__owner);
        
        Canary.__warp_constructor_0(__warp_19__owner);
        
        
        
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


// Contract Def ERC721Metadata@interface


@contract_interface
namespace ERC721Metadata_warped_interface{
func tokenURI_c87b56dd(_tokenId : Uint256)-> (__warp_0_len : felt, __warp_0 : felt*){
}
}


// Contract Def IERC721@interface


@contract_interface
namespace IERC721_warped_interface{
func transferFrom_23b872dd(_from : felt, _to : felt, _tokenId : Uint256)-> (){
}
}


// Contract Def Token@interface


@contract_interface
namespace Token_warped_interface{
func mint_40c10f19(_platform : felt, _amount : Uint256)-> (){
}
func burn_9dc29fac(_platform : felt, _amount : Uint256)-> (){
}
func transfer_a9059cbb(_to : felt, _value : Uint256)-> (success : felt){
}
}