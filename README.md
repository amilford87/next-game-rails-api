### Next-Game

A pick-up sports game locator and match-up. When searching for an outdoor pick-up sports game, our algorithm will suggest games within your schedule, near you. Results are weighted on how many players have already joined as well as proximity. If there are no games near you or within your time preferences it will also suggest parks for you to start your own game for others to join

* Sign up / Login capabilities
* Choose your preferences
* Select from a list of games
* Save games you wish to attend

## To Run

Download or clone.
Start the server by running 'rails s' in the terminal.

Download or clone the [front end](https://github.com/amilford87/next-game-react-app)

After the server is up and running, run the front end with npm start in the terminal to launch.

Runs the app in the development mode.<br>
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

## Screenshots

![Next-Game Home](https://github.com/amilford87/next-game-react-app/blob/master/assets/home.png)
![Next-Game Signup](https://github.com/amilford87/next-game-react-app/blob/master/assets/signup.png)
![Next-Game Preferences](https://github.com/amilford87/next-game-react-app/blob/master/assets/preferences.png)
![Next-Game Select Game 1](https://github.com/amilford87/next-game-react-app/blob/master/assets/select-game-1.png)
![Next-Game Select Game 5](https://github.com/amilford87/next-game-react-app/blob/master/assets/select-game-5.png)
![Next-Game Saved Game](https://github.com/amilford87/next-game-react-app/blob/master/assets/saved-games.png)

## Dependencies

* Ruby 2.3.5
* Rails 5.2.3
* PostgreSQL (pg)
* puma
* nokogiri
* bcrypt
* faker
* rack-cors
* geocoder