import os
from discord_webhook import DiscordWebhook


def main():
    DISCORD_WEBHOOK_URL = os.getenv("DISCORD_WEBHOOK_URL")
    webhook = DiscordWebhook(url=DISCORD_WEBHOOK_URL, content="Webhook Message")
    webhook.execute()


if __name__ == "__main__":
    main()
