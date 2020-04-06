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
	Life: 0
};
var TotalOrbs = 0;
var DeadOrbs = 0;
var ToGet = 0;
var NuLevelTimer = false;
var Orbs = [];
var GameLevel = 0; /* Placeholder for whatever is checked in a menu system */
var GameLevelProgress = []; /* Placeholder for whatever is checked in a menu system */

var ScreenWidth = 550;
var ScreenHeight = 400;
var OrbRadius = 7;

function startgame()
{
	console.log("startgame()");
	/* Clear the screen */
	GameArea.innerHTML = "";
	/* Set up a canvas */
	let GameCanvas = D.createElement('canvas');
	GameCanvas.setAttribute("id", "arena");
	GameCanvas.setAttribute("width", ScreenWidth + "px");
	GameCanvas.setAttribute("height", ScreenHeight + "px");
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
	LoadLevel(1);
}

function LoadLevel(level)
{
	console.log("LoadLevel(" + level + ")");
	let x = 0;
	if ((level < 1) || (level > 12))
	{
		console.log('LoadLevel: level=' . level);
		return;
	}
	let OrbMax = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]; /* How many orbs to put on the screen */
	let getOrbs = [1, 2, 3, 5, 7, 10, 15, 21, 27, 33, 44, 55]; /* How many orbs to get to complete the level */
	TotalOrbs = OrbMax[level - 1];
	Toget = getOrbs[level - 1];
	for (x = 1; x <= 12; x++)
	{
		GameLevelProgress[x] = false;
	}
	for (x = 1; x <= level; x++)
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
	CreateOrbs(TotalOrbs);
	ShowOrbs();
	setTimeout(MoveOrbs, 50); /* 20 refreshes per second */
}

function CreateOrbs(count_of_orbs)
{
	let x = 0, y = 0;
	let OrbColliding = false;
	console.log("CreateOrbs(" + count_of_orbs + ")");
	TotalOrbs = count_of_orbs; /* Should be obviously set, but just to make sure we set it again */
	/* Create TotalOrbs orb objects */
	Orbs = [];
	for (x = 0; x < TotalOrbs; x++)
	{
		Orbs[x] = {
			XCoord: 0,
			YCoord: 0,
			Angle: 0,
			Speed: 0,
			Radius: 0,
			clrRed: 0,
			clrGreen: 0,
			clrBlue: 0,
			State: 0, /* 0=dead, 1=mini, 2=growing, 3=big (uses life), 4=shrinking */
			Life: 0
		};
	}
	for (x = 0; x < TotalOrbs; x++)
	{
		do {
			OrbColliding = false;
			Orbs[x].XCoord = Math.floor(Math.random() * ScreenWidth) + 1;
			Orbs[x].YCoord = Math.floor(Math.random() * ScreenHeight) + 1;
			Orbs[x].Radius = OrbRadius;
			if (x > 0)
			{
				for (y = 0; y < x; y++)
				{
					if (OrbCollision(Orbs[x].XCoord, Orbs[x].YCoord, Orbs[x].Radius + 1, Orbs[y].XCoord, Orbs[y].YCoord, Orbs[y].Radius + 1))
					{
						OrbColliding = true;
					}
				}
			}
		} while (OrbColliding == true);
		do {
			Orbs[x].Angle = Math.floor(Math.random() * 359);
		} while ((Orbs[x].Angle % 90) == 0);
		Orbs[x].Speed = 3;
		Orbs[x].clrRed = Math.floor(Math.random() * 256); /* 24-bit RGB color */
		Orbs[x].clrGreen = Math.floor(Math.random() * 256); /* 24-bit RGB color */
		Orbs[x].clrBlue = Math.floor(Math.random() * 256); /* 24-bit RGB color */
		Orbs[x].State = 1;
		Orbs[x].Life = 21;
		console.log("Orb: " + Orbs[x]);
	}
	Explosive.DidClick = false;
	Explosive.Radius = 2;
	Explosive.Life = 20;
	return;
}

function OrbCollision(x1, y1, r1, x2, y2, r2)
{
	let OrbDist = Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
	if ((r1 + r2) >= OrbDist)
	{
		return true;
	}
	return false;
}

function ShowOrbs()
{
	console.log("ShowOrbs()");
	let arena = D.getElementById('arena');
	// background is black
	let bg = arena.getContext("2d");
	bg.rect(0, 0, ScreenWidth,ScreenHeight);
	bg.fillStyle = 'black';
	bg.fill();

	DeadOrbs = 0;
	let x = 0;
	for (x = 0; x < TotalOrbs; x++)
	{
		if (Orbs[x].Radius > 0)
		{
			canvasCircle(arena, Orbs[x].XCoord, Orbs[x].YCoord, Orbs[x].Radius, Orbs[x].clrRed, Orbs[x].clrGreen, Orbs[x].clrBlue);
		}
		if (Orbs[x].State != 1)
		{
			DeadOrbs++;
		}
	}
	if (Explosive.DidClick == true)
	{
		canvasCircle(arena, Explosive.XCoord, Explosive.YCoord, Explosive.Radius, 255, 255, 255);
	}
	return;
}

function canvasCircle(canvas, x, y, radius, clrRed, clrGreen, clrBlue)
{
	let circle = canvas.getContext("2d");
	circle.beginPath();
	circle.arc(x, y, radius, 0, 2 * Math.PI);
	circle.fillStyle = "rgb(" + clrRed + "," + clrGreen + "," + clrBlue + ")";
	circle.strokeStyle = "rgb(" + clrRed + "," + clrGreen + "," + clrBlue + ")";
	circle.lineWidth = 0;
	circle.fill();
	circle.stroke();
	return;
}

// TODO
/* Some timer function */
function MoveOrbs()
{
	console.log("MoveOrbs()");
	/* If we're still in the game we can call ourselves back in 50ms */
	// setTimeout(MoveOrbs, 50);
	return;
}