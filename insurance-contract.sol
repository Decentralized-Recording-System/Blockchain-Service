// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract DRS_DATA_STORE {
    struct ContractData {
        address user;
        address company;
        uint256 contractValue;
        string start;
        string expire;
    }

    struct SetOfAddress {
        uint256 sizeOfSet;
        address[] values;
        mapping(address => bool) is_in;
    }

    struct Company {
        ContractData[] data;
    }

    mapping(address => Company) private companies;
    SetOfAddress private _companySetAddress;
    address[] private _adminAddress = [
        0x71CB05EE1b1F506fF321Da3dac38f25c0c9ce6E1,
        0x2c41E9c7A248d955493Ba6D8A26722ee3dB9631f,
        0x6D9f4d92839c5BCe7C4Dd958605dFc1C2eBdE7Fd
    ];

    function getSizeOfCompanyAddress() public view returns (uint256) {
        return _companySetAddress.sizeOfSet;
    }

    function getAllCompanyAddress() public view returns (address[] memory) {
        address[] memory result = new address[](_companySetAddress.sizeOfSet);
        for (uint256 i = 0; i < _companySetAddress.sizeOfSet; i++) {
            result[i] = _companySetAddress.values[i];
        }
        return result;
    }

    function addCompanyAddress(address member) public returns (string memory) {
        require(
            !_companySetAddress.is_in[member],
            "Error address is in company address"
        );
        require(
            msg.sender == _adminAddress[0] ||
                msg.sender == _adminAddress[1] ||
                msg.sender == _adminAddress[2],
            "You are not an admin"
        );

        _companySetAddress.values.push(member);
        _companySetAddress.is_in[member] = true;
        _companySetAddress.sizeOfSet++;

        return "Succeed";
    }

    function createContract(ContractData memory _data)
        public
        returns (string memory)
    {
        require(
            !_companySetAddress.is_in[msg.sender],
            "Error address is in company address"
        );
        companies[msg.sender].data.push(_data);

        return "Succeed";
    }

    function getAllContract() public view returns (ContractData[] memory) {
        require(
            !_companySetAddress.is_in[msg.sender],
            "Error address is in company address"
        );
        return companies[msg.sender].data;
    }
}
