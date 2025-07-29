import { useState } from "react";

function Square({ value, onSquareClick, classN }) {
  return (
    <button className={classN} onClick={onSquareClick}>
      {value}
    </button>
  );
}

function Board({ xIsNext, squares, onPlay }) {
  function handleClick(i) {
    if (calculateWinner(squares) || squares[i]) {
      return;
    }
    const nextSquares = squares.slice();
    if (xIsNext) {
      nextSquares[i] = "X";
    } else {
      nextSquares[i] = "O";
    }

    let [col, lin] = [Math.floor(i / 3), i % 3];
    onPlay(nextSquares, col, lin);
  }

  const winner = calculateWinner(squares);
  let status;
  if (winner !== "draw" && winner !== null) {
    status = "Winner: " + winner[0];
  } else if (winner === "draw") {
    status = "It's a draw!";
  } else {
    status = "Next player: " + (xIsNext ? "X" : "O");
  }

  let s = [];
  let d = [];

  for (let j = 0; j < 9; j++) {
    if (winner !== null && winner !== "draw") {
      if (winner.constructor === Array) {
        if (j == Number(winner[1]) || j == winner[2] || j == winner[3])
          s.push(
            <Square
              value={squares[j]}
              onSquareClick={() => handleClick(j)}
              classN={"winning-square"}
            />
          );
        else
          s.push(
            <Square
              value={squares[j]}
              onSquareClick={() => handleClick(j)}
              classN={"square"}
            />
          );
      }
    } else {
      s.push(
        <Square
          value={squares[j]}
          onSquareClick={() => handleClick(j)}
          classN={"square"}
        />
      );
    }
  }

  for (let i = 0; i < 3; i++) {
    d.push(<div className="board-row">{s.slice(3 * i, 3 * i + 3)}</div>);
  }

  return (
    <>
      <div className="status">{status}</div>
      {d}
    </>
  );
}

export default function Game() {
  const [history, setHistory] = useState([Array(9).fill(null)]);
  const [currentMove, setCurrentMove] = useState(0);
  const xIsNext = currentMove % 2 === 0;
  const currentSquares = history[currentMove];
  const [isToggled, setIsToggled] = useState(true);
  const [moves, setMoves] = useState([
    <li key={0}>
      <button onClick={() => jumpTo(move)}>Go to game start</button>
    </li>,
  ]);
  const [positions, setPositions] = useState([]);

  function handlePlay(nextSquares, col, lin) {
    const nextHistory = [...history.slice(0, currentMove + 1), nextSquares];
    setHistory(nextHistory);
    setCurrentMove(nextHistory.length - 1);
    const nextPositions = [...positions.slice(0, currentMove + 1), [col, lin]];
    setPositions(nextPositions);
    console.log(nextPositions);

    let m = nextHistory.map((squares, move) => {
      let description;
      let s;

      if (move > 0) {
        if (move == nextHistory.length - 1) {
          s = (
            <label>
              You are at move #{move}. Position: [{nextPositions[move - 1][0]},
              {nextPositions[move - 1][1]}]
            </label>
          );
        } else {
          description =
            "Go to move #" +
            move +
            ". Position: [" +
            nextPositions[move - 1][0] +
            ", " +
            nextPositions[move - 1][1] +
            "]";
          s = <button onClick={() => jumpTo(move)}>{description}</button>;
        }
      } else {
        description = "Go to game start";
        s = <button onClick={() => jumpTo(move)}>{description}</button>;
      }

      return <li key={move}>{s}</li>;
    });
    setMoves(m);
  }

  function jumpTo(nextMove) {
    setCurrentMove(nextMove);
  }

  function handleToggle() {
    setMoves(moves.reverse());
    setIsToggled(!isToggled);
  }

  return (
    <div className="game">
      <div className="game-board">
        <Board xIsNext={xIsNext} squares={currentSquares} onPlay={handlePlay} />
      </div>
      <div className="game-info">
        <label>Order moves ascending? </label>
        <button onClick={handleToggle}>
          {isToggled === true ? "ON" : "OFF"}
        </button>
        <ol>{moves}</ol>
      </div>
    </div>
  );
}

function calculateWinner(squares) {
  const lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  let ok = 1;
  for (let i = 0; i < lines.length; i++) {
    const [a, b, c] = lines[i];
    if (squares[a] === null || squares[b] === null || squares[c] === null)
      ok = 0;
    if (squares[a] && squares[a] === squares[b] && squares[a] === squares[c]) {
      return [squares[a], a, b, c];
    }
  }
  if (ok == 1) return "draw";
  return null;
}
