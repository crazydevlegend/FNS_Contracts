pragma solidity >=0.8.4;
import "../ResolverBase.sol";

abstract contract NameResolver is ResolverBase {
    bytes4 private constant NAME_INTERFACE_ID = 0x691f3431;

    event NameChanged(bytes32 indexed node, string name);

    mapping(bytes32 => string) names;

    /**
     * Sets the name associated with an FNS node, for reverse records.
     * May only be called by the owner of that node in the FNS registry.
     * @param node The node to update.
     * @param name The name to set.
     */
    function setName(bytes32 node, string calldata name)
        external
        authorised(node)
    {
        names[node] = name;
        emit NameChanged(node, name);
    }

    /**
     * Returns the name associated with an FNS node, for reverse records.
     * Defined in EIP181.
     * @param node The FNS node to query.
     * @return The associated name.
     */
    function name(bytes32 node) external view returns (string memory) {
        return names[node];
    }

    function supportsInterface(bytes4 interfaceID)
        public
        pure
        virtual
        override
        returns (bool)
    {
        return
            interfaceID == NAME_INTERFACE_ID ||
            super.supportsInterface(interfaceID);
    }
}
