# telgram-musicbot
A Telegram musicbot

# How to run
- Get a bot token from BotFather, see [docs here](https://core.telegram.org/bots#3-how-do-i-create-a-bot).
- Clone repository
- Run `bundle` (optional maybe? do it just to be sure)
- Set the token in the `TELEGRAM_MUSICBOT_TOKEN` environment variable
  - Linux/OSX: `export TELEGRAM_MUSICBOT_TOKEN=<your token>`
  - Windows: `SET TELEGRAM_MUSICBOT_TOKEN=<your token>``
- Run `ruby bot.rb`

# To-dos
Want to have more fun? Send pull requests for these open items.

- A bot interface to add clips
- Leaderboard
- Accept approximate answers (for example, `Metalica` matches, maybe less points).
- Points for artist, record and title
