pragma solidity >=0.8.4;
import "../ResolverBase.sol";

abstract contract TextResolver is ResolverBase {
    bytes4 private constant TEXT_INTERFACE_ID = 0x59d1d43c;

    event TextChanged(
        bytes32 indexed node,
        string indexed indexedKey,
        string key
    );

    mapping(bytes32 => mapping(string => string)) texts;

    /**
     * Sets the text data associated with an FNS node and key.
     * May only be called by the owner of that node in the FNS registry.
     * @param node The node to update.
     * @param key The key to set.
     * @param value The text data value to set.
     */
    function setText(
        bytes32 node,
        string calldata key,
        string calldata value
    ) external authorised(node) {
        texts[node][key] = value;
        emit TextChanged(node, key, key);
    }

    /**
     * Returns the text data associated with an FNS node and key.
     * @param node The FNS node to query.
     * @param key The text data key to query.
     * @return The associated text data.
     */
    function text(bytes32 node, string calldata key)
        external
        view
        returns (string memory)
    {
        return texts[node][key];
    }

    function supportsInterface(bytes4 interfaceID)
        public
        pure
        virtual
        override
        returns (bool)
    {
        return
            interfaceID == TEXT_INTERFACE_ID ||
            super.supportsInterface(interfaceID);
    }
}
