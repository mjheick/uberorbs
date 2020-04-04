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
var gamearea = D.getElementById('game-area');

/**
 * startgame
 *
 * This starts the game
 */
function startgame()
{
	/* Clear the screen */
	gamearea.innerHTML = "";
	/* Set up a canvas */
	let gamecanvas = D.createElement('canvas');
	gamecanvas.setAttribute("id", "arena");
	gamecanvas.setAttribute("class", "uberorbs-game");
	gamearea.appendChild(gamecanvas);
}

/**
 * ---------- Below is many of the visual basic routines ported to Javascript ----------
 */
