pragma solidity ^0.4.21;

contract exchange {
    struct Data {
        address a;
        address b;
        bytes32 a_hash;
        bytes32 b_hash;
        uint32 height;
        uint256 money;
        address erc20;
    }

    mapping(address => Data) m_data;

    function exchange() public {}

    function sha_256(bytes32 r) public constant returns (bytes32) {
        return sha256(r);
    }

    function In(
        address b_,
        bytes32 a_hash_,
        bytes32 b_hash_,
        uint32 height_,
        uint256 money_,
        address erc20_
    ) public payable returns (bytes32) {
        m_data[msg.sender] = Data({
            a : msg.sender
            b : b_,
            a_hash : a_hash_,
            b_hash : b_hash_,
            height : height_,
            money : money_,
            erc20 : erc20_
        });
        return data[msg.sender].a;
    }

    function Out1(
        address owner,
        bytes32 a_,
        bytes32 b_
    ) public constant returns (bool) {
        if (
            block.number < data[owner].h &&
            sha256(a_) == data[owner].a &&
            sha256(b_) == data[owner].b
        ) {
            data[owner].other.send(data[owner].m);
            return true;
        } else {
            return false;
        }
    }

    function Out2(address owner) public constant returns (bool) {
        if (data[msg.sender].h < block.number) {
            msg.sender.send(data[msg.sender].m);
            return true;
        } else {
            return false;
        }
    }

    function GetData(address owner) public constant returns (bytes32) {
        return data[owner].a;
    }

    mapping(bytes32 => Data) data_erc20;

    function InErc20(
        address other_,
        bytes32 a_,
        bytes32 b_,
        uint32 h_,
        address erc20_,
        uint256 money_
    ) public returns (bytes32) {
        data_erc20[msg.sender] = Data({
            other: other_,
            a: a_,
            b: b_,
            h: h_,
            m: money_,
            erc20: erc20_
        });
        return data[msg.sender].a;
    }
}
