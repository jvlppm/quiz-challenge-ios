# Quiz Challenge

## Project Description
As a mobile engineer, I've been tasked with the development of an app for playing word quizzes.
This first version (MVP) of the app should be very simple. The app will be fed with content from a server.
I should follow the design specs given. The app should work and behave correctly both in landscape
and portrait orientations. The development approach is for me to decide based on previous experience
and/or personal interest.

## Functional Requirements
The first release of the app will be very limited in scope, but will serve as the foundation for future
releases. It's expected that the player will be able to:
- Insert words and have them counted as a hit as soon as the player types the last letter of each
word.
- After a hit, the input box will be cleared and focus will remain on the input box.
- There will be a 5 min timer to finish the game.
  - If the player completes the quiz in less than 5 min, an alert will praise him.
  - If the player doesn't complete within 5 min, an alert will tell him his score.
- There will be a button to start the timer.

## Technical Requirements
I should see this project as an opportunity to create an app following modern development best
practices (given your platform of choice), but I am also free to use my own app architecture
preferences (coding standards, code organization, etc), although third-party libraries must NOT be
used.
The list of words will be retrieved from the following endpoint:
-  https://codechallenge.arctouch.com/quiz/1

## Implementation
It was decided to use XCode as my platform of choice, with screens implemented
with storyboards as I am most comfortable with.

No special instructions are required to build, but you may need to update the
project bundle ID, as it may have been associated with my account.
