module MRWeaponS1::config {

    use std::signer;
    use std::string;
    use aptos_framework::account;
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::coin;

    friend MRWeaponS1::weapon;

    const SEED: vector<u8> = b"Mirror Realms";
    const Precision: u64 = 1000;

    struct Weapon has key, store, drop, copy {
        tokenNamePrefix: string::String,
        tokenDescription: string::String,
        collectionName: string::String,
        collectionDescription: string::String,
        types: vector<string::String>,
        typeIDs: vector<u64>,
        images: vector<string::String>,
        collectionImage: string::String,
        qualityRanges: vector<vector<u8>>,
        qualityProbability: vector<u64>,
        qualityColor: vector<string::String>,
        properties: vector<string::String>,
        propertiesPerQuality: vector<u64>,

        globalFreeze: bool,
    }

    struct Config has key {
        adminCap: account::SignerCapability,
    }

    fun init_module(sender: &signer) {
        let (signer, cap) = account::create_resource_account(sender, SEED);
        coin::register<AptosCoin>(&signer);
        let config = Config {
            adminCap: cap,
        };

        move_to(&signer, Weapon {
            tokenNamePrefix: string::utf8(b"Weapon T1"),
            tokenDescription: string::utf8(b"Mirror Realms Weapon Test1"),
            collectionName: string::utf8(b"MR Weapon"),
            collectionDescription: string::utf8(b"Mirror Realms Weapon Test1"),
            types: vector[
                string::utf8(b"Big Sword"),
                string::utf8(b"Bow"),
                string::utf8(b"One Handed Sword"),
            ],
            typeIDs: vector[
                1000002301,
                1000003301,
               1000001301,
            ],
            images: vector[
                string::utf8(
                    b"https://kgcdn.shenmezhideke.com/big_sword.png?x-oss-process=style/nft"
                ),
                string::utf8(
                    b"https://kgcdn.shenmezhideke.com/bow.png?x-oss-process=style/nft"
                ),
                string::utf8(
                    b"https://kgcdn.shenmezhideke.com/one_handed_sword.png?x-oss-process=style/nft"
                ),
            ],
            collectionImage: string::utf8(
                b"https://kgcdn.shenmezhideke.com/weaponnft.png?x-oss-process=style/nft"
            ),
            qualityRanges: vector[
                vector[0, 19],
                vector[20, 49],
                vector[50, 79],
                vector[80, 99],
                vector[100, 100],
            ],
            qualityColor: vector[
                string::utf8(b"White"),
                string::utf8(b"Green"),
                string::utf8(b"Blue"),
                string::utf8(b"Purple"),
                string::utf8(b"Yellow")
            ],
            qualityProbability: vector[
                10_000,
                30_000,
                30_000,
                20_000,
                10_000
            ],
            properties: vector[
                string::utf8(b"ATK"),
                string::utf8(b"CRT"),
                string::utf8(b"DEF"),
                string::utf8(b"ENG"),
                string::utf8(b"EVD")
            ],
            propertiesPerQuality: vector[
                20,
                20,
                20,
                20,
                20,
            ],
            globalFreeze: false
        });
        move_to(&signer, config);
    }


    // Friend
    public(friend) fun get_resource_signer(): signer acquires Config {
        account::create_signer_with_capability(&borrow_global<Config>(get_resource_address()).adminCap)
    }

    // public
    #[view]
    public fun get_precision(): u64 {
        Precision
    }

    #[view]
    public fun get_resource_address(): address {
        account::create_resource_address(&@MRWeaponS1, SEED)
    }

    #[view]
    public fun get_weapon_types(): vector<string::String> acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).types
    }

    #[view]
    public fun get_weapon_quality_ranges(): vector<vector<u8>> acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).qualityRanges
    }

    #[view]
    public fun get_weapon_quality_probability(): vector<u64> acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).qualityProbability
    }

    #[view]
    public fun get_weapon_properties(): vector<string::String> acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).properties
    }

    #[view]
    public fun get_weapon_properties_per_quality(): vector<u64> acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).propertiesPerQuality
    }

    #[view]
    public fun get_global_freeze(): bool acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).globalFreeze
    }

    #[view]
    public fun get_weapon_quality_color(): vector<string::String> acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).qualityColor
    }

    #[view]
    public fun get_weapon_images(): vector<string::String> acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).images
    }

    #[view]
    public fun get_weapon_collection_image(): string::String acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).collectionImage
    }

    #[view]
    public fun get_weapon_token_name_prefix(): string::String acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).tokenNamePrefix
    }

    #[view]
    public fun get_weapon_token_description(): string::String acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).tokenDescription
    }

    #[view]
    public fun get_weapon_collection_name(): string::String acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).collectionName
    }

    #[view]
    public fun get_weapon_collection_description(): string::String acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).collectionDescription
    }

    #[view]
    public fun get_weapon_type_ids():vector<u64> acquires Weapon {
        borrow_global<Weapon>(get_resource_address()).typeIDs
    }

    // admin

    public entry fun set_weapon_types(sender: &signer, types: vector<string::String>) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.types = types;
    }

    public entry fun set_weapon_quality_ranges(sender: &signer, qualityRanges: vector<vector<u8>>) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.qualityRanges = qualityRanges;
    }

    public entry fun set_weapon_quality_probability(sender: &signer, qualityProbability: vector<u64>) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.qualityProbability = qualityProbability;
    }

    public entry fun set_weapon_properties(sender: &signer, properties: vector<string::String>) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.properties = properties;
    }

    public entry fun set_weapon_properties_per_quality(
        sender: &signer,
        propertiesPerQuality: vector<u64>
    ) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.propertiesPerQuality = propertiesPerQuality;
    }

    public entry fun set_global_freeze(sender: &signer, globalFreeze: bool) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.globalFreeze = globalFreeze;
    }

    public entry fun set_weapon_quality_color(sender: &signer, qualityColor: vector<string::String>) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.qualityColor = qualityColor;
    }

    public entry fun set_weapon_images(sender: &signer, images: vector<string::String>) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.images = images;
    }

    public entry fun set_weapon_collection_image(sender: &signer, collectionImage: string::String) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.collectionImage = collectionImage;
    }

    public entry fun set_weapon_token_name_prefix(sender: &signer, tokenNamePrefix: string::String) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.tokenNamePrefix = tokenNamePrefix;
    }

    public entry fun set_weapon_token_description(sender: &signer, tokenDescription: string::String) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.tokenDescription = tokenDescription;
    }

    public entry fun set_weapon_collection_name(sender: &signer, collectionName: string::String) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.collectionName = collectionName;
    }

    public entry fun set_weapon_collection_description(sender: &signer, collectionDescription: string::String) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.collectionDescription = collectionDescription;
    }

    public entry fun set_weapon_type_ids(sender: &signer, typeIDs: vector<u64>) acquires Weapon {
        assert!(@MRWeaponS1 == signer::address_of(sender), 1);
        let weapon = borrow_global_mut<Weapon>(get_resource_address());
        weapon.typeIDs = typeIDs;
    }
}
