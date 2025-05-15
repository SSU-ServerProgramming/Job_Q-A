from dataclasses import dataclass, asdict
from typing import Any, Optional

@dataclass
class Response:
    status: str
    data: Optional[Any] = None
    message: Optional[str] = None

    def to_dict(self):
        result = {"status": self.status}
        if self.data is not None:
            result["data"] = self.data
        if self.message is not None:
            result["message"] = self.message
        return result

    @classmethod
    def success(cls, data: Any = None):
        if isinstance(data, dict) and 'message' in data:
            data = {k: v for k, v in data.items() if k != 'message'}
        return cls(status="success", data=data, message=None)

    @classmethod
    def error(cls, message: str):
        return cls(status="error", data=None, message=message) 