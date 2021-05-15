import command

const theMessage = """
Do not waste people's time, when you have a question just ask the question.
By asking for a specific person you will not get an answer just a message in a Discord server.
If you want to search for people with specific knowledge go outside and ask around.
"""

command:
  name: justask
  description: "Sends a message to people that like wasting time"
  body:
    sendMessage(theMessage)
