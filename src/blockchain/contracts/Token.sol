// SPDX-License-Identifier: MIT

//Este contrato lidará com a criação de tokens correspondentes ao valor do pagamento. 
//Ele emitirá um evento quando os tokens forem criados com sucesso.

pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    // Define the event to be emitted on successful token creation
    event TokensCreated(address indexed to, uint256 amount);

    constructor() public ERC20("NrsimhadevaToken", "NT") {
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }

    function createTokens(address to, uint256 amount) public {
        _mint(to, amount);
        emit TokensCreated(to, amount);
    }
}
