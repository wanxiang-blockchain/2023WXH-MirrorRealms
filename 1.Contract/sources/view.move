module MRWeaponS1::view {
    use std::string;

    struct Collection has copy,drop{
        creator: address,
        description: string::String,
        name: string::String,
        uri: string::String,
    }

    public fun create(creator: address, description: string::String, name: string::String, uri: string::String): Collection {
        Collection{
            creator,
            description,
            name,
            uri,
        }
    }

}
