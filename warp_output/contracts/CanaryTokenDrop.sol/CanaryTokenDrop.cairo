%lang starknet


from warplib.maths.external_input_check_ints import warp_external_input_check_int256
from warplib.maths.external_input_check_address import warp_external_input_check_address
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address
from warplib.maths.ge import warp_ge256
from warplib.maths.le import warp_le256


func WS0_READ_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: felt){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
}

func WS1_READ_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: Uint256){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    let (read1) = WARP_STORAGE.read(loc + 1);
    return (Uint256(low=read0,high=read1),);
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


// Contract Def CanaryTokenDrop


@event
func Droped_2b84f454(claimer : felt, amount_claimed : Uint256){
}

namespace CanaryTokenDrop{

    // Dynamic variables - Arrays and Maps

    // Static variables

    const __warp_0_canary = 0;

    const __warp_1_maximumToClaim = 1;


    func __warp_constructor_0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_2__canary : felt)-> (){
    alloc_locals;


        
        WS_WRITE0(__warp_0_canary, __warp_2__canary);
        
        WS_WRITE1(__warp_1_maximumToClaim, Uint256(low=10000000000000000000, high=0));
        
        
        
        return ();

    }

}


    @external
    func drop_211d9a53{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_3__amount : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_3__amount);
        
        let (__warp_se_0) = WS0_READ_felt(CanaryTokenDrop.__warp_0_canary);
        
        let (__warp_se_1) = get_contract_address();
        
        let (__warp_pse_0) = CanaryToken_warped_interface.balanceOf_70a08231(__warp_se_0, __warp_se_1);
        
        let (__warp_se_2) = warp_ge256(__warp_pse_0, __warp_3__amount);
        
        with_attr error_message("not enough to drop"){
            assert __warp_se_2 = 1;
        }
        
        let (__warp_se_3) = WS1_READ_Uint256(CanaryTokenDrop.__warp_1_maximumToClaim);
        
        let (__warp_se_4) = warp_le256(__warp_3__amount, __warp_se_3);
        
        with_attr error_message("cannot claim more than 10 CanaryTokens"){
            assert __warp_se_4 = 1;
        }
        
        let (__warp_se_5) = WS0_READ_felt(CanaryTokenDrop.__warp_0_canary);
        
        let (__warp_se_6) = get_caller_address();
        
        CanaryToken_warped_interface.transfer_a9059cbb(__warp_se_5, __warp_se_6, __warp_3__amount);
        
        
        
        return ();

    }


    @view
    func maximumToClaim_bc6032a9{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_4 : Uint256){
    alloc_locals;


        
        let (__warp_se_7) = WS1_READ_Uint256(CanaryTokenDrop.__warp_1_maximumToClaim);
        
        
        
        return (__warp_se_7,);

    }


    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_2__canary : felt){
    alloc_locals;
    WARP_USED_STORAGE.write(3);


        
        warp_external_input_check_address(__warp_2__canary);
        
        CanaryTokenDrop.__warp_constructor_0(__warp_2__canary);
        
        
        
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


// Contract Def CanaryToken@interface


@contract_interface
namespace CanaryToken_warped_interface{
func balanceOf_70a08231(_owner : felt)-> (balance : Uint256){
}
func transfer_a9059cbb(_to : felt, _value : Uint256)-> (success : felt){
}
}