module MRWeaponS1::weapon {
    use std::bcs;
    use std::hash;
    use std::option;
    use std::signer;
    use std::string;
    use std::vector;
    use aptos_std::from_bcs;
    use aptos_std::string_utils;
    use aptos_std::type_info;
    use aptos_framework::account;
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::block;
    use aptos_framework::coin;
    use aptos_framework::event;
    use aptos_framework::object;
    use aptos_framework::object::Object;
    use aptos_framework::timestamp;
    use MRWeaponS1::view;

    use aptos_token_objects::collection;
    use aptos_token_objects::property_map;
    use aptos_token_objects::token;

    use MRWeaponS1::config::{Self, get_resource_address};

    // admin
    entry fun startSell(sender: &signer) acquires State {
        assert!(signer::address_of(sender) == @MRWeaponS1, 1);
        borrow_global_mut<State>(get_resource_address()).sellConfig.started = true;
    }

    entry fun stopSell(sender: &signer) acquires State {
        assert!(signer::address_of(sender) == @MRWeaponS1, 1);
        borrow_global_mut<State>(get_resource_address()).sellConfig.started = false;
    }


    // Error
    const EInsufficientFundsError: u64 = 100;
    const EInvalidCoinType: u64 = 101;
    const ESaleNotStarted: u64 = 102;
    const ESoldOut: u64 = 103;
    const EInvalidTokenOwner: u64 = 104;
    const EInvalidTokenName: u64 = 105;
    const EGloablFreeze: u64 = 106;

    const TokenPropertyMapKey: vector<vector<u8>> = vector[
        b"Weapon Type",
        b"Weapon ID",
        b"Quality",
        b"Prop1",
        b"Prop2",
    ];

    const TokenPropertyMapType: vector<vector<u8>> = vector[
        b"0x1::string::String",
        b"u64",
        b"u64",
        b"0x1::string::String",
        b"0x1::string::String",
    ];

    struct SellConfig has store {
        price: u64,
        coinType: string::String,
        started: bool,
        count: u64,
        maxCount: option::Option<u64>,
    }

    struct TokenRef has key {
        mutatorRef: token::MutatorRef,
        propertyMutatorRef: property_map::MutatorRef,
        burnRef: token::BurnRef,
        extendRef: object::ExtendRef,
        transferRef: object::TransferRef
    }

    struct Weapon has key, copy, drop, store {
        name: string::String,
        quality: u64,
        color: string::String,
        typeIndex: u64,
        skills: vector<Skill>,
    }

    struct Skill has store, drop, copy {
        typeIndex: u64,
        name: string::String,
        rating: u64,
    }

    struct MintEvent has store, drop, copy {
        user: address,
        tokenName: string::String,
        collectionName: string::String,
        weapon: Weapon,
        blockHeight: u64
    }

    struct CraftedEvent has store, drop, copy {
        user: address,
        oldTokenNames: vector<string::String>,
        oldCollectionNames: vector<string::String>,
        oldWeapons: vector<Weapon>,
        newWeapon: Weapon,
        blockHeight: u64
    }

    struct Collection has store {
        mutatorRef: collection::MutatorRef
    }

    struct State has key {
        sellConfig: SellConfig,
        collection: Collection,
        carftCount: u64,
        gruid: u64,
        mint_event_handler: event::EventHandle<MintEvent>,
        crafted_event_handler: event::EventHandle<CraftedEvent>
    }

    fun init_module(_sender: &signer) {
        let signer = &config::get_resource_signer();
        let collectionConstructorRef = collection::create_unlimited_collection(
            signer, config::get_weapon_collection_description(),
            config::get_weapon_collection_name(),
            option::none(),
            config::get_weapon_collection_image()
        );

        move_to(signer, State {
            sellConfig: SellConfig {
                price: 2 * 10_000_000,
                coinType: type_info::type_name<AptosCoin>(),
                started: false,
                count: 0,
                maxCount: option::some(5_000),
            },
            gruid: 0,
            collection: Collection {
                mutatorRef: collection::generate_mutator_ref(&collectionConstructorRef),
            },
            carftCount: 5_000,
            mint_event_handler: account::new_event_handle(signer),
            crafted_event_handler: account::new_event_handle(signer)
        })
    }

    entry fun mint(sender: &signer) acquires State {
        let sender_address = signer::address_of(sender);
        let resource_address = get_resource_address();
        let state = borrow_global_mut<State>(resource_address);
        let resource_signer = &config::get_resource_signer();


        // Assert Freeze
        assert!(config::get_global_freeze() == false, EGloablFreeze);
        // Assert Mint
        assert_user_balance<AptosCoin>(sender_address, state.sellConfig.coinType, state.sellConfig.price);
        assert_sell_status(state.sellConfig.started);
        assert_sell_count(
            state.sellConfig.count,
            *option::borrow_with_default(&state.sellConfig.maxCount, &18_446_744_073_709_551_615)
        );

        // Sell One
        state.sellConfig.count = state.sellConfig.count + 1;
        state.gruid = state.gruid + 1;


        // Transfer Coin
        coin::transfer<AptosCoin>(sender, resource_address, state.sellConfig.price);

        // Get Random Weapon

        let weapon = get_random_weapon(sender_address, state.gruid);


        let tokenName = config::get_weapon_token_name_prefix();
        string::append(&mut tokenName, string_utils::format1(&b" #{}", state.gruid));
        // Mint Token
        let token_ref = token::create_named_token(
            resource_signer,
            config::get_weapon_collection_name(),
            config::get_weapon_token_description(),
            tokenName,
            option::none(),
            *vector::borrow(&config::get_weapon_images(), weapon.typeIndex),
        );

        let token_signer = &object::generate_signer(&token_ref);

        let prop1 = vector::borrow(&weapon.skills, 0).name;
        string::append(
            &mut prop1,
            string_utils::format2(
                &b" +{}.{}%",
                vector::borrow(&weapon.skills, 0).rating / 100,
                (vector::borrow(&weapon.skills, 0).rating % 100) / 10
            )
        );
        let prop2 = vector::borrow(&weapon.skills, 1).name;
        string::append(
            &mut prop2,
            string_utils::format2(
                &b" +{}.{}%",
                vector::borrow(&weapon.skills, 1).rating / 100,
                (vector::borrow(&weapon.skills, 1).rating % 100) / 10
            )
        );

        let propertyMutatorRef = property_map::generate_mutator_ref(&token_ref);
        let token_property = property_map::prepare_input(
            vector::map_ref(
                &TokenPropertyMapKey,
                | key | {
                    let key: &vector<u8> = key;
                    string::utf8(*key)
                }
            ),
            vector::map_ref(
                &TokenPropertyMapType,
                | type | {
                    let type: &vector<u8> = type;
                    string::utf8(*type)
                }
            ),
            vector[
                bcs::to_bytes(&weapon.name),
                bcs::to_bytes(vector::borrow(&config::get_weapon_type_ids(),weapon.typeIndex )),
                bcs::to_bytes(&weapon.quality),
                bcs::to_bytes(&prop1),
                bcs::to_bytes(&prop2),
            ]
        );

        property_map::init(&token_ref, token_property);

        move_to(token_signer, TokenRef {
            mutatorRef: token::generate_mutator_ref(&token_ref),
            propertyMutatorRef,
            burnRef: token::generate_burn_ref(&token_ref),
            extendRef: object::generate_extend_ref(&token_ref),
            transferRef: object::generate_transfer_ref(&token_ref)
        });

        move_to(token_signer, weapon);

        // Transfer Token
        object::transfer(resource_signer, object::object_from_constructor_ref<Weapon>(&token_ref), sender_address);

        event::emit_event(&mut state.mint_event_handler, MintEvent {
            user: sender_address,
            tokenName,
            collectionName: config::get_weapon_collection_name(),
            weapon,
            blockHeight: block::get_current_block_height() + 1
        })
    }

    entry public fun craft_by_object(sender: &signer,
                                     weapon1_object: Object<Weapon>,
                                     weapon2_object: Object<Weapon>) acquires State, Weapon, TokenRef {
        let sender_address = signer::address_of(sender);
        let resource_address = get_resource_address();
        let state = borrow_global_mut<State>(resource_address);
        let resource_signer = &config::get_resource_signer();

        // Assert Freeze
        assert!(config::get_global_freeze() == false, EGloablFreeze);

        // Assert Token Owner
        let weapon1 = object::object_address(&weapon1_object);
        let weapon2 = object::object_address(&weapon2_object);
        assert!(weapon1 != weapon2, EInvalidTokenName);
        assert!(object::is_owner(weapon1_object, sender_address), EInvalidTokenOwner);
        assert!(object::is_owner(weapon2_object, sender_address), EInvalidTokenOwner);
        state.carftCount = state.carftCount + 1;
        state.gruid = state.gruid + 1;

        let weapon1_object = object::address_to_object<token::Token>(weapon1);
        let weapon2_object = object::address_to_object<token::Token>(weapon2);

        let weapon1_struct = move_from<Weapon>(weapon1);
        let weapon2_struct = move_from<Weapon>(weapon2);

        let TokenRef {
            mutatorRef: _,
            propertyMutatorRef: propertyMutatorRef1,
            burnRef: burnRef1,
            extendRef: _,
            transferRef: _
        } = move_from<TokenRef>(weapon1);
        let TokenRef {
            mutatorRef: _,
            propertyMutatorRef: propertyMutatorRef2,
            burnRef: burnRef2,
            extendRef: _,
            transferRef: _
        } = move_from<TokenRef>(weapon2);

        property_map::burn(propertyMutatorRef1);
        property_map::burn(propertyMutatorRef2);

        // Get New Weapon

        let newWeapon = get_random_weapon_by_old(sender_address, &weapon1_struct, &weapon2_struct);

        // Get New Token
        let tokenName = config::get_weapon_token_name_prefix();
        string::append(&mut tokenName, string_utils::format1(&b" #{}", state.gruid));

        let token_ref = token::create_named_token(
            resource_signer,
            config::get_weapon_collection_name(),
            config::get_weapon_token_description(),
            tokenName,
            option::none(),
            *vector::borrow(&config::get_weapon_images(), newWeapon.typeIndex),
        );

        let token_signer = &object::generate_signer(&token_ref);
        let prop1 = vector::borrow(&newWeapon.skills, 0).name;
        string::append(
            &mut prop1,
            string_utils::format2(
                &b" +{}.{}%",
                vector::borrow(&newWeapon.skills, 0).rating / 100,
                (vector::borrow(&newWeapon.skills, 0).rating% 100) / 10
            )
        );
        let prop2 = vector::borrow(&newWeapon.skills, 1).name;
        string::append(
            &mut prop2,
            string_utils::format2(
                &b" +{}.{}%",
                vector::borrow(&newWeapon.skills, 1).rating / 100,
                (vector::borrow(&newWeapon.skills, 1).rating % 100)/ 10
            )
        );

        let propertyMutatorRef = property_map::generate_mutator_ref(&token_ref);
        let token_property = property_map::prepare_input(
            vector::map_ref(
                &TokenPropertyMapKey,
                | key | {
                    let key: &vector<u8> = key;
                    string::utf8(*key)
                }
            ),
            vector::map_ref(
                &TokenPropertyMapType,
                | type | {
                    let type: &vector<u8> = type;
                    string::utf8(*type)
                }
            ),
            vector[
                bcs::to_bytes(&newWeapon.name),
                bcs::to_bytes(vector::borrow(&config::get_weapon_type_ids(),newWeapon.typeIndex )),
                bcs::to_bytes(&newWeapon.quality),
                bcs::to_bytes(&prop1),
                bcs::to_bytes(&prop2),
            ]
        );

        property_map::init(&token_ref, token_property);
        move_to(token_signer, TokenRef {
            mutatorRef: token::generate_mutator_ref(&token_ref),
            propertyMutatorRef,
            burnRef: token::generate_burn_ref(&token_ref),
            extendRef: object::generate_extend_ref(&token_ref),
            transferRef: object::generate_transfer_ref(&token_ref)
        });


        move_to(token_signer, newWeapon);

        // Transfer Token
        object::transfer(resource_signer, object::object_from_constructor_ref<Weapon>(&token_ref), sender_address);

        event::emit_event(&mut state.crafted_event_handler, CraftedEvent {
            user: sender_address,
            oldTokenNames: vector[
                token::name(weapon1_object),
                token::name(weapon2_object)
            ],
            oldCollectionNames: vector[
                token::collection_name(weapon1_object),
                token::collection_name(weapon2_object)
            ],
            oldWeapons: vector[
                weapon1_struct,
                weapon2_struct
            ],
            newWeapon,
            blockHeight: block::get_current_block_height() + 1
        });

        // Burn Token
        token::burn(burnRef1);
        token::burn(burnRef2);
    }

    entry fun craft(
        sender: &signer,
        weapon1_name: string::String,
        weapon2_name: string::String
    ) acquires State, Weapon, TokenRef {
        craft_by_object(sender, object::address_to_object<Weapon>(
            token::create_token_address(
                &get_resource_address(),
                &config::get_weapon_collection_name(),
                &weapon1_name
            ),
        )
            , object::address_to_object<Weapon>(
                token::create_token_address(
                    &get_resource_address(),
                    &config::get_weapon_collection_name(),
                    &weapon2_name
                )
            )
        );
    }


    // assert
    public fun assert_user_balance<CoinType>(user: address, coinType: string::String, amount: u64) {
        assert!(type_info::type_name<CoinType>() == coinType, EInvalidCoinType);
        assert!(coin::balance<CoinType>(user) >= amount, EInsufficientFundsError);
    }

    public fun assert_sell_status(status: bool) {
        assert!(status, ESaleNotStarted);
    }

    public fun assert_sell_count(count: u64, maxCount: u64) {
        assert!(count < maxCount, ESoldOut);
    }

    public fun assert_token_owner<TokenType: key>(owner: address, token: address) {
        assert!(owner == object::owner(object::address_to_object<TokenType>(token)), EInvalidTokenOwner);
    }


    // Private
    fun get_random_weapon(sender_address: address, count: u64): Weapon {
        let account_id = account::get_guid_next_creation_num(sender_address);
        let sequence = account::get_sequence_number(sender_address);
        let height = block::get_current_block_height();
        let time = timestamp::now_microseconds();
        let origin = vector::empty();
        vector::append(&mut origin, bcs::to_bytes(&sender_address));
        vector::append(&mut origin, bcs::to_bytes(&count));
        vector::append(&mut origin, bcs::to_bytes(&coin::balance<AptosCoin>(get_resource_address())));
        vector::append(&mut origin, bcs::to_bytes(&sequence));
        vector::append(&mut origin, bcs::to_bytes(&account_id));
        vector::append(&mut origin, bcs::to_bytes(&height));
        vector::append(&mut origin, bcs::to_bytes(&time));

        let hash = hash::sha3_256(origin);


        // Weapon Type

        let weaponType = config::get_weapon_types();
        let weaponTypeIndex = (from_bcs::to_u8(vector[
            *vector::borrow(&hash, 0)
        ]) as u64) % vector::length(&weaponType);


        let weaponQualityRanges = config::get_weapon_quality_ranges();
        let weaponQualityRangeIndex = {
            let probability = config::get_weapon_quality_probability();
            let random = (from_bcs::to_u32(vector[
                *vector::borrow(&hash, 1),
                *vector::borrow(&hash, 2),
                *vector::borrow(&hash, 3),
                *vector::borrow(&hash, 4)
            ]) as u64) % 100_000;

            let i = 0;
            let value = 0;
            while (i < vector::length(&probability)) {
                if (random < (value + *vector::borrow(&probability, i))) {
                    break
                };
                value = value + *vector::borrow(&probability, i);
                i = i + 1;
            };
            i
        };


        let weaponQualityRangeUp = *vector::borrow(vector::borrow(&weaponQualityRanges, weaponQualityRangeIndex), 1);
        let weaponQualityRangeDown = *vector::borrow(vector::borrow(&weaponQualityRanges, weaponQualityRangeIndex), 0);


        let weaponQuality = ((from_bcs::to_u8(vector[
            *vector::borrow(&hash, 3)
        ]) % (weaponQualityRangeUp - weaponQualityRangeDown + 1) + weaponQualityRangeDown) as u64);

        let weaponColor = config::get_weapon_quality_color();


        let properties = config::get_weapon_properties();
        let properties_per = config::get_weapon_properties_per_quality();

        let weaponSkill1 = (from_bcs::to_u8(vector[
            *vector::borrow(&hash, 4)
        ]) as u64) % vector::length(&properties);


        let weaponSkill1Value = *vector::borrow(&properties_per, weaponSkill1) * weaponQuality;

        let weaponSkill2 = ((from_bcs::to_u8(vector[
            *vector::borrow(&hash, 5)
        ]) as u64) % vector::length(&properties));

        let weaponSkill2Value = *vector::borrow(&properties_per, weaponSkill2) * weaponQuality;

        Weapon {
            name: *vector::borrow(&weaponType, weaponTypeIndex),
            quality: weaponQuality,
            color: *vector::borrow(&weaponColor, weaponQualityRangeIndex),
            typeIndex: weaponTypeIndex,
            skills: vector[
                Skill {
                    typeIndex: weaponSkill1,
                    name: *vector::borrow(&properties, weaponSkill1),
                    rating: weaponSkill1Value
                },
                Skill {
                    typeIndex: weaponSkill2,
                    name: *vector::borrow(&properties, weaponSkill2),
                    rating: weaponSkill2Value
                }
            ],
        }
    }

    fun get_random_weapon_by_old(sender_address: address, weapon1: &Weapon, weapon2: &Weapon): Weapon {
        let account_id = account::get_guid_next_creation_num(sender_address);
        let sequence = account::get_sequence_number(sender_address);
        let height = block::get_current_block_height();
        let time = timestamp::now_microseconds();
        let origin = vector::empty();
        vector::append(&mut origin, bcs::to_bytes(&sender_address));
        vector::append(&mut origin, bcs::to_bytes(&coin::balance<AptosCoin>(get_resource_address())));
        vector::append(&mut origin, bcs::to_bytes(&sequence));
        vector::append(&mut origin, bcs::to_bytes(&account_id));
        vector::append(&mut origin, bcs::to_bytes(&height));
        vector::append(&mut origin, bcs::to_bytes(&time));

        let hash = hash::sha3_256(origin);

        // Weapon Type
        let weaponType = config::get_weapon_types();
        let weaponTypeIndex = if ((from_bcs::to_u8(vector[
            *vector::borrow(&hash, 0)
        ]) as u64) % 2 == 0) {
            weapon1.typeIndex
        } else {
            weapon2.typeIndex
        };

        let weaponQualityRanges = config::get_weapon_quality_ranges();
        // Weapon Quality and Color
        let weaponQualityRangeIndex = {
            let probability = config::get_weapon_quality_probability();
            let random = (from_bcs::to_u32(vector[
                *vector::borrow(&hash, 1),
                *vector::borrow(&hash, 2),
                *vector::borrow(&hash, 3),
                *vector::borrow(&hash, 4)
            ]) as u64) % 100_000;

            let i = 0;
            let value = 0;
            while (i < vector::length(&probability)) {
                if (random < (value + *vector::borrow(&probability, i))) {
                    break
                };
                value = value + *vector::borrow(&probability, i);
                i = i + 1;
            };
            i
        };

        let weaponQualityRangeUp = *vector::borrow(vector::borrow(&weaponQualityRanges, weaponQualityRangeIndex), 1);
        let weaponQualityRangeDown = *vector::borrow(vector::borrow(&weaponQualityRanges, weaponQualityRangeIndex), 0);


        let weaponQuality = ((from_bcs::to_u8(vector[
            *vector::borrow(&hash, 2)
        ]) % (weaponQualityRangeUp - weaponQualityRangeDown + 1) + weaponQualityRangeDown) as u64);


        let weaponColor = config::get_weapon_quality_color();

        // Weapon Skill

        let oldWeaponSkillVec = vector::empty();
        vector::append(&mut oldWeaponSkillVec, vector::map_ref(&weapon1.skills, | skill | {
            let skill: &Skill = skill;
            skill.typeIndex
        }));
        vector::append(&mut oldWeaponSkillVec, vector::map_ref(&weapon2.skills, | skill | {
            let skill: &Skill = skill;
            skill.typeIndex
        }));
        let properties = config::get_weapon_properties();
        let properties_per = config::get_weapon_properties_per_quality();
        let weaponSkill1 = *vector::borrow(&oldWeaponSkillVec, ((from_bcs::to_u8(vector[
            *vector::borrow(&hash, 3)
        ]) % 4) as u64));
        let weaponSkill1Value = *vector::borrow(&properties_per, weaponSkill1) * weaponQuality;

        let weaponSkill2 =  *vector::borrow(&oldWeaponSkillVec, ((from_bcs::to_u8(vector[
            *vector::borrow(&hash, 4)
        ]) % 4) as u64));
        let weaponSkill2Value = *vector::borrow(&properties_per, weaponSkill2) * weaponQuality;

        Weapon {
            name: *vector::borrow(&weaponType, weaponTypeIndex),
            quality: weaponQuality,
            color: *vector::borrow(&weaponColor, weaponQualityRangeIndex),
            typeIndex: weaponTypeIndex,
            skills: vector[
                Skill {
                    typeIndex: weaponSkill1,
                    name: *vector::borrow(&properties, weaponSkill1),
                    rating: weaponSkill1Value
                },
                Skill {
                    typeIndex: weaponSkill2,
                    name: *vector::borrow(&properties, weaponSkill2),
                    rating: weaponSkill2Value
                }
            ],
        }
    }


    struct WeaponMetaData has copy,drop {
        name: string::String,
        description: string::String,
        uri: string::String,
        collection: view::Collection,
        weapon: Weapon
    }

    // view
    #[view]
    fun get_weapon_by_object( weapon :Object<Weapon>):WeaponMetaData acquires Weapon {
        let weapon_struct = borrow_global<Weapon>(object::object_address(&weapon));
        let collection = token::collection_object(weapon);
        WeaponMetaData{
            name: token::name(weapon),
            uri: token::uri(weapon),
            description: token::description(weapon),
            collection:view::create(
                collection::creator(collection),
                collection::description(collection),
                collection::name(collection),
                collection::uri(collection)
            ),
            weapon: *weapon_struct
        }
    }

    #[view]
    fun get_weapon_by_name(weapon_name: string::String):WeaponMetaData acquires Weapon {
        let weapon = token::create_token_address(
            &get_resource_address(),
            &config::get_weapon_collection_name(),
            &weapon_name
        );
        get_weapon_by_object(object::address_to_object<Weapon>(weapon))
    }
}
