# Sui Videogame ⚔️

**Sui Videogame** is a smart contract module written in **Move (Sui blockchain)**.  

It allows players to create knights, explore dungeons, face enemies, collect treasures, and manage their progress.

---

## Features ✨

- Create new knights with custom names.  
- Send knights to explore dungeons (limited attempts per day).  
- Random dungeon outcomes:  
  - Nothing happens.  
  - Treasure with score rewards.  
  - Enemy encounters with damage.  
- Reset knight health and attempts daily.  
- Sacrifice knights to permanently remove them.  
- Error handling with custom codes.  

---

## Project Structure 📂

```plaintext
├── sources/
│   └── sui_videogame.move   # Main module with structs, errors, and functions
├── Move.toml                # Project configuration file
└── README.md                # Project documentation
```
---

## Module Overview 📘

### Structs
- **Knight** → Represents a playable knight.  
  - `id` → unique identifier (UID).  
  - `name` → custom knight name.  
  - `key_used` → number of dungeon attempts used today.  
  - `last_attempt_day` → last day the knight entered a dungeon.  
  - `score` → accumulated score from treasures.  
  - `health` → current health points.  

- **DungeonContent** → Possible dungeon outcomes.  
  - `None` → no effect.  
  - `Treasure {score}` → knight finds treasure and earns points.  
  - `Enemy {health}` → knight encounters an enemy and takes damage.  

---

### Errors
- **E_NAME_NOT_VALID (0)** → Knight name is invalid (empty string).  
- **E_DONT_HAVE_KEYS (1)** → No more dungeon attempts left for today.  
- **E_KNIGHT_DEAD (2)** → The knight has no health left to explore.  

---

### Main Functions
- **`create_knight(name: String, ctx: &mut TxContext)`**  
  Creates a new knight with the given name.  

- **`send_knight_to_dungeon(knight: &mut Knight, clock: &Clock, r: &Random, ctx: &mut TxContext)`**  
  Sends a knight to the dungeon, consuming one attempt and producing a random outcome.  

- **`sacrifice_knight(knight: Knight)`**  
  Permanently deletes the knight from storage.  

---

## Technologies 🛠️

- **Move Language** 🦀 – smart contract programming  
- **Sui Blockchain** 🌐 – execution environment  
- **Sui CLI** 💻 – building, testing, and publishing modules  

---

## Contributions 🤝  

Contributions are welcome!  

Fork this repository, create a new branch, make your changes, and open a *pull request*.  

---

## License 📜  

[MIT](https://choosealicense.com/licenses/mit/)  
