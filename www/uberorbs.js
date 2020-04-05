/**
 * Uberorbs, (c)2007 unliterate.net
 * Originally written in VB6, ported to Javascript
 */

/**
 * global shortcuts
 */
var D = document;
var W = window;

/**
 * global variables and types
 */
var GameArea = D.getElementById('game-area');

var Explosive = {
	DidClick: false,
	XCoord: 0,
	YCoord: 0,
	Radius: 0,
	Life: 0,
};
var TotalOrbs = 0;
var DeadOrbs = 0;
var ToGet = 0;
var NuLevelTimer = false;
var Orbs = [];
var GameLevel = 0; /* Placeholder for whatever is checked in a menu system */
var GameLevelProgress = []; /* Placeholder for whatever is checked in a menu system */

function startgame()
{
	console.log("startgame()");
	/* Clear the screen */
	GameArea.innerHTML = "";
	/* Set up a canvas */
	let GameCanvas = D.createElement('canvas');
	GameCanvas.setAttribute("id", "arena");
	GameCanvas.setAttribute("class", "uberorbs-game");
	GameArea.appendChild(GameCanvas);

	/* Game Init Form_Load */
	TotalOrbs = 0;
	for (let x = 0; x <= 11; x++)
	{
		GameLevelProgress[x] = false;
	}
	/* PlaySound 4 */

	StartNewGame();
}

function StartNewGame()
{
	console.log("StartNewGame()");
	LoadLevel(0);
}

function LoadLevel(level)
{
	console.log("LoadLevel(" + level + ")");
	let x = 0;
	if ((level < 0) || (level > 11))
	{
		console.log('LoadLevel: level=' . level);
		return;
	}
	let Orbs = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]; /* How many orbs to put on the screen */
	let getOrbs = [1, 2, 3, 5, 7, 10, 15, 21, 27, 33, 44, 55]; /* How many orbs to get to complete the level */
	TotalOrbs = Orbs[level];
	Toget = getOrbs[level];
	for (x = 0; x <= 11; x++)
	{
		GameLevelProgress[x] = false;
	}
	for (x = 0; x <= level; x++)
	{
		GameLevelProgress[x] = true
	}
	GameLevel = level;
	PlayGame();
}

function PlayGame()
{
	console.log("PlayGame()");
	if (TotalOrbs == 0)
	{
		TotalOrbs = 50;
	}
	CreateOrbs(TotalOrbs)
	ShowOrbs();
	setTimeout(MoveOrbs, 50); /* 20 refreshes per second */
}

function CreateOrbs(count_of_orbs)
{
	console.log("CreateOrbs(" + count_of_orbs + ")");
	return;
}

function ShowOrbs()
{
	console.log("ShowOrbs()");
	return;
}

/* Some timer function */
function MoveOrbs()
{
	console.log("MoveOrbs()");
	/* If we're still in the game we can call ourselves back in 50ms */
	// setTimeout(MoveOrbs, 50);
	return;
}