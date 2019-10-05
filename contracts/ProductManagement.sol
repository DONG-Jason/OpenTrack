pragma solidity >=0.4.21 <0.6.0;

contract ProductManagement{
    struct Part {
        address manufacturer;
        string serial_number;
        string part_type;
        string creation_date;
    }

    struct Product{
        address manufacturer;
        string serial_number;
        string product_type;
        string creation_date;
        bytes32[6] parts;
    }

    mapping(bytes32 => Part) public parts;
    mapping(bytes32 => Product) public products;
}

constructor() public{

}

//function to hash the total info
function concatenateInfoAndHash(address a1, string memory s1, string memory s2, string memory s3) private returns (bytes32){
        //First, get all values as bytes
        bytes20 b_a1 = bytes20(a1);
        bytes memory b_s1 = bytes(s1);
        bytes memory b_s2 = bytes(s2);
        bytes memory b_s3 = bytes(s3);

        //Then calculate and reserve a space for the full string
        string memory s_full = new string(b_a1.length + b_s1.length + b_s2.length + b_s3.length);
        bytes memory b_full = bytes(s_full);
        uint j = 0;
        uint i;
        for(i = 0; i < b_a1.length; i++){
            b_full[j++] = b_a1[i];
        }
        for(i = 0; i < b_s1.length; i++){
            b_full[j++] = b_s1[i];
        }
        for(i = 0; i < b_s2.length; i++){
            b_full[j++] = b_s2[i];
        }
        for(i = 0; i < b_s3.length; i++){
            b_full[j++] = b_s3[i];
        }

        //Hash the result and return
        return keccak256(b_full);
}

function buildPart(string memory serial_num,string memory part_type, string memory creation_date) public returns(byte32){
    //create hash and then check if it exists. If doesn't create the part and return id to user.
    bytes32 part_hash = concatenateInfoAndHash(msg.sender, serial_num, part_type, creation_date);
    //check if part id is free to use or not
    require(parts[part_hash].manufacturer == address(0), "Part ID already used");

    Part memory new_part = Part(msg.sender, serial_num, part_type, creation_date);
    parts[part_hash] = new_part;
    return part_hash;
}


