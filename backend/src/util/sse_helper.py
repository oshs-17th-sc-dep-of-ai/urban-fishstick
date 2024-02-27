from dataclasses import dataclass

@dataclass
class ServerSentEvent:
    data: str
    event: str | None = None
    id: str | None = None
    retry: int | None = None

    def encode(self) -> bytes:
        message = f"data: {self.data}"

        if self.event is not None:
            message += f"\nevent: {self.event}"
        if self.id is not None:
            message += f"\nid: {self.id}"
        if self.retry is not None:
            message += f"\nretry: {self.retry}"

        message += "\r\n\r\n"

        return message.encode("utf-8")
