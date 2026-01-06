# NautobotGPT Chat Commands

## `/nautobotgpt` Command

Interact with NautobotGPT by utilizing the following sub-commands:

| Command | Arguments | Description |
|-------- | --------- | ----------- |
| `ask` | | Ask NautobotGPT a question. |

!!! note
    All sub-commands are intended to be used with the `/nautobotgpt` prefix.

## `/nautobotgpt ask` Command

Ask NautobotGPT a question about your Nautobot instance. The command will return a response based on the context of your Nautobot data.

### Usage

```shell
/nautobotgpt ask <question>
```

### Example

```shell
/nautobotgpt ask "What are the available devices in my Nautobot instance?"
```

### Response

NautobotGPT will analyze the question and provide a response based on the data available in your Nautobot instance. The response may include information about devices, circuits, IP addresses, or any other relevant data stored in Nautobot.

It can also analyze and respond with general information about Nautobot, such as its features, capabilities, documentation, and how to use it effectively.
