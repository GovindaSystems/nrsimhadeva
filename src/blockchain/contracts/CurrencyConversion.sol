// SPDX-License-Identifier: MIT

//Este contrato será responsável por converter o valor do pagamento em criptomoeda. 
//Ele usará Chainlink para buscar a taxa de câmbio atual e calcular o valor equivalente da criptomoeda.

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

contract CurrencyConversion is ChainlinkClient {
    // Define the address of the oracle that will perform the Chainlink request
    address private oracle;
    // Define the job id to be requested
    bytes32 private jobId;
    // Define the fee to be paid for the Chainlink request
    uint256 private fee;
    // Define the event to be emitted on successful conversion
    event ConversionCompleted(uint256 cryptoAmount);

    constructor(address _oracle, bytes32 _jobId, uint256 _fee) public {
        setPublicChainlinkToken();
        oracle = _oracle;
        jobId = _jobId;
        fee = _fee;
    }

    function convertFiatToCrypto(uint256 fiatAmount) public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        // Add the fiat amount as a request parameter
        request.addUint("fiatAmount", fiatAmount);
        // Send the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfill(bytes32 _requestId, uint256 cryptoAmount) public recordChainlinkFulfillment(_requestId) {
        emit ConversionCompleted(cryptoAmount);
    }
}
