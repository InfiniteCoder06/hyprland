import abc
from lib.helper import show_header, show_step, show_sub_step, new_line

class Module(abc.ABC):
    name: str = ""
    description: str = ""
    title: str = ""
    messages: list[str] = []

    def __init__(self):
        self.greet()
        self.info()
        new_line()

    def greet(self):
        show_header(self.name, self.description)

    def info(self):
        show_step(self.title)
        for message in self.messages:
            show_sub_step(message)

    @abc.abstractmethod
    def run(self):
        pass