module sui_videogame::sui_videogame;
    use std::string::String;
    use sui::random::Random;
    use sui::clock::{Clock, timestamp_ms};
    use sui::random::new_generator;

    // ===========================
    // Structs
    // ===========================

    public struct Knight has key {
        id: UID,
        name: String,
        key_used: u8,
        last_attempt_day: u64,
        score: u64,
        health: u8,
    }

    // ===========================
    // Enums
    // ===========================

    public enum DungeonContent has drop {
        None,
        Treasure {score: u64},
        Enemy {health: u8},
    }

    // ===========================
    // Errors
    // ===========================

    #[error]
    const E_NAME_NOT_VALID: vector<u8> = b"Knight name is not valid";
    #[error]
    const E_DONT_HAVE_KEYS: vector<u8> = b"You don't have enough keys to enter the dungeon";
    #[error]
    const E_KNIGHT_DEAD: vector<u8> = b"Your knight has no health left to continue exploring";

    // ===========================
    // Functions
    // ===========================
    
    /// Generates a random number in the range `[min, max]` using Sui's random generator.
    #[allow(lint(public_random))]
    public fun random_generator(random: &Random, min: u8, max: u8, ctx: &mut TxContext): u8 {
        let mut generator = new_generator(random, ctx);

        generator.generate_u8_in_range(min, max)
    }

    /// Creates a new Knight with the given `name`.
    #[allow(lint(self_transfer))]
    public fun create_knight(name: String, ctx: &mut TxContext) {
        assert!(name.length() > 0, E_NAME_NOT_VALID);

        let knight = Knight {
            id: object::new(ctx),
            name,
            key_used: 0,
            last_attempt_day: 0,
            score: 0,
            health: 100,
        };

        transfer::transfer(knight, ctx.sender());
    }

    /// Sends a knight to explore the dungeon.
    #[allow(lint(public_random))]
    public fun send_knight_to_dungeon(knight: &mut Knight, clock: &Clock, r: &Random, ctx: &mut TxContext): DungeonContent {
        let last_day = knight.last_attempt_day / 86400000;
        let current_day = timestamp_ms(clock) / 86400000;

        // Reset daily stats if new day
        if (current_day > last_day) {
            knight.last_attempt_day = timestamp_ms(clock);
            knight.key_used = 0;
            knight.health = 100;
        };
      
        // Ensure knight has attempts and health available
        assert!(knight.key_used < 3, E_DONT_HAVE_KEYS);
        assert!(knight.health > 0, E_KNIGHT_DEAD);

        // Consume a dungeon attempt
        knight.key_used = knight.key_used + 1;

        // Roll the outcome
        let roll = random_generator(r, 1, 3, ctx);

        if (roll == 2) {
            let points = random_generator(r, 10, 100, ctx);
            knight.score = knight.score + {points as u64};
            DungeonContent::Treasure {score: points as u64}
        } else if (roll == 3) {
            let damage = random_generator(r, 1, 100, ctx);
            assert!(knight.health > damage, E_KNIGHT_DEAD);
            knight.health = knight.health - damage;
            DungeonContent::Enemy {health: damage}
        } else {
            DungeonContent::None
        }
    }

    /// Permanently sacrifices a knight, removing it from storage.
    public fun sacrifice_knight(knight: Knight) {
        let Knight {id, name: _, key_used: _, last_attempt_day: _, score: _, health: _} = knight;

        id.delete();
    }