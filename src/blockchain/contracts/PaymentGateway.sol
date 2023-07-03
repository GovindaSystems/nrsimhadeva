// SPDX-License-Identifier: MIT

//Este contrato lidará com a comunicação com o gateway de pagamento. 
//Ele receberá o webhook do gateway de pagamento e emitirá um evento quando um pagamento for recebido e validado.

pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

contract PaymentGatewayContract is ChainlinkClient {
    // Define the address of the oracle that will perform the Chainlink request
    address private oracle;
    // Define the job id to be requested
    bytes32 private jobId;
    // Define the fee to be paid for the Chainlink request
    uint256 private fee;
    // Define the event to be emitted on payment validation
    event PaymentReceived(address payer, uint256 amount);

    constructor(address _oracle, bytes32 _jobId, uint256 _fee) public {
        setPublicChainlinkToken();
        oracle = _oracle;
        jobId = _jobId;
        fee = _fee;
    }

    function validatePayment(address payer, uint256 amount) public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        // Add the payer address and payment amount as request parameters
        request.add("payer", string(abi.encodePacked(payer)));
        request.addUint("amount", amount);
        // Send the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfill(bytes32 _requestId, bool paymentValid) public payable recordChainlinkFulfillment(_requestId) {
        if (paymentValid) {
            emit PaymentReceived(msg.sender, msg.value);
        }
    }
}

