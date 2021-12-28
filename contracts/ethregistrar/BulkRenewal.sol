pragma solidity >=0.8.4;
pragma experimental ABIEncoderV2;

import "../registry/FNS.sol";
import "./ETHRegistrarController.sol";
import "../resolvers/Resolver.sol";

contract BulkRenewal {
    bytes32 private constant ETH_NAMEHASH =
        0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    bytes4 private constant REGISTRAR_CONTROLLER_ID = 0x018fac06;
    bytes4 private constant INTERFACE_META_ID =
        bytes4(keccak256("supportsInterface(bytes4)"));
    bytes4 public constant BULK_RENEWAL_ID =
        bytes4(
            keccak256("rentPrice(string[],uint)") ^
                keccak256("renewAll(string[],uint")
        );

    FNS public fns;

    constructor(FNS _fns) public {
        fns = _fns;
    }

    function getController() internal view returns (ETHRegistrarController) {
        Resolver r = Resolver(fns.resolver(ETH_NAMEHASH));
        return
            ETHRegistrarController(
                r.interfaceImplementer(ETH_NAMEHASH, REGISTRAR_CONTROLLER_ID)
            );
    }

    function rentPrice(string[] calldata names, uint256 duration)
        external
        view
        returns (uint256 total)
    {
        ETHRegistrarController controller = getController();
        for (uint256 i = 0; i < names.length; i++) {
            total += controller.rentPrice(names[i], duration);
        }
    }

    function renewAll(string[] calldata names, uint256 duration)
        external
        payable
    {
        ETHRegistrarController controller = getController();
        for (uint256 i = 0; i < names.length; i++) {
            uint256 cost = controller.rentPrice(names[i], duration);
            controller.renew{value: cost}(names[i], duration);
        }
        // Send any excess funds back
        payable(msg.sender).transfer(address(this).balance);
    }

    function supportsInterface(bytes4 interfaceID)
        external
        pure
        returns (bool)
    {
        return
            interfaceID == INTERFACE_META_ID || interfaceID == BULK_RENEWAL_ID;
    }
}
