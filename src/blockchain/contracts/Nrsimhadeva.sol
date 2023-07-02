// SPDX-License-Identifier: MIT

//Este é o contrato principal que interage com os contratos acima. 
//Ele orquestrará o processo de receber o webhook do gateway de pagamento, confirmar o pagamento, converter o valor do pagamento em criptomoeda e criar a quantidade correspondente de tokens.

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./PaymentGateway.sol";
import "./CurrencyConversion.sol";
import "./Token.sol";

contract NrsimhadevaContract {
    PaymentGatewayContract public paymentGatewayContract;
    CurrencyConversionContract public currencyConversionContract;
    Token public token;

    constructor(
        PaymentGatewayContract _paymentGatewayContract,
        CurrencyConversionContract _currencyConversionContract,
        Token _token
    ) public {
        paymentGatewayContract = _paymentGatewayContract;
        currencyConversionContract = _currencyConversionContract;
        token = _token;
    }

    function processPayment(address payer, uint256 amount) public {
        // Validate the payment
        paymentGatewayContract.validatePayment(payer, amount);
        // Convert the payment amount to cryptocurrency
        uint256 cryptoAmount = currencyConversionContract.convertFiatToCrypto(amount);
        // Create tokens corresponding to the payment amount
        Token.createTokens(payer, cryptoAmount);
    }
}
