# Diamond-Starknet

## changes made

seletor from bytes4 to bytes32 (since selectors on starknet have 250 bits)

AppStorage as an external contract (to replace first YUL block in fallback function of Diamond.sol)

delegateCall in fallback function (to replace second YUL block in fallback function of Diamond.sol)

internal calls from facets now become external calls to the AppStorage contract


## need to be done

hardcode the address of the AppStorage in the transpiled contracts (until find a better alternative)

find a alternative logic to replace `msg.sig` and `msg.data` from fallback function of the Diamond.sol file