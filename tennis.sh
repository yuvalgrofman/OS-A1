#!/bin/bash
#yuval grofman 214975245


#initializeGame is responsible for initializing the game state variables
initializeGame() {
    gameOver=false

    player1Points=50
    player2Points=50
    player1Input=0
    player2Input=0

    ballPosition=0

    echo -e " Player 1: ${player1Points}         Player 2: ${player2Points} "
    echo " --------------------------------- "
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    echo " |       |       O       |       | "
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    echo " --------------------------------- "
}

#printGameState is responsible for printing the game state to the screen
printGameState() {

    echo -e " Player 1: ${player1Points}         Player 2: ${player2Points} "
    echo " --------------------------------- "
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "

    if ((ballPosition == 3)); then
        echo " |       |       #       |       |O"
    elif ((ballPosition == 2)); then
        echo " |       |       #       |   O   | "
    elif ((ballPosition == 1)); then
        echo " |       |       #   O   |       | "
    elif ((ballPosition == 0)); then
        echo " |       |       O       |       | "
    elif ((ballPosition == -1)); then
        echo " |       |   O   #       |       | "
    elif ((ballPosition == -2)); then
        echo " |   O   |       #       |       | "
    elif ((ballPosition == -3)); then
        echo "O|       |       #       |       | "
    fi


    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    echo " --------------------------------- "

    echo -e "       Player 1 played: $player1Input"
    echo -e "       Player 2 played: $player2Input"
    echo 
    echo
}

#getPlayerInput is responsible for getting the player input from the user
getPlayerInput() {
    re='^[0-9]+$'

    player1InputValid=false
    player2InputValid=false


    while [ $player1InputValid = false ]; do
        read -s -p "Player 1 PICK A NUMBER: " player1Input 
        echo

        if ! [[ $player1Input =~ $re ]]; then
            echo "NOT A VALID MOVE !"
        elif ((player1Input < 0 || player1Input > player1Points)); then
            echo "NOT A VALID MOVE !"
        else 
            player1InputValid=true
        fi
    done

    while [ $player2InputValid = false ]; do
        read -s -p "Player 2 PICK A NUMBER: " player2Input 
        echo

        if ! [[ $player2Input =~ $re ]]; then
            echo "NOT A VALID MOVE !"
        elif ((player2Input < 0 || player2Input > player2Points)); then
            echo "NOT A VALID MOVE !"
        else
            player2InputValid=true
        fi
    done

}

#updateGameState is responsible for updating the game state variables
updateGameState() {
    player1Points=$((player1Points - player1Input))
    player2Points=$((player2Points - player2Input))

    if ((player1Input > player2Input)); then
        if ((ballPosition >= 0)); then
            ballPosition=$((ballPosition + 1))
        else 
            ballPosition=1
        fi
    elif ((player1Input < player2Input)); then
        if ((ballPosition <= 0)); then
            ballPosition=$((ballPosition - 1))
        else 
            ballPosition=-1
        fi
    fi
}

#checkGameOver is responsible for checking if the game is over
checkGameOver() {

    if ((ballPosition == 3)); then
        echo "Player 1 Wins !"
        gameOver=true

    elif ((ballPosition == -3)); then
        echo "Player 2 Wins !"
        gameOver=true
    elif ((player1Points == 0 && player2Points == 0)); then
        if ((ballPosition > 0)); then
            echo "Player 1 Wins !"
        elif ((ballPosition < 0)); then
            echo "Player 2 Wins !"
        else
            echo "IT'S A DRAW !"
        fi
        gameOver=true

    elif ((player1Points == 0)); then
        echo "Player 2 Wins !"
        gameOver=true

    elif ((player2Points == 0)); then
        echo "Player 1 Wins !"
        gameOver=true
    fi
}

#runGame is responsible for running the game loop
runGame() {
    initializeGame

    while [ $gameOver = false ]; do
        getPlayerInput
        updateGameState
        printGameState
        checkGameOver
    done
}

runGame