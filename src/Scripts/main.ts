'use strict';

function activate(): void {
	console.log('Activated!');

	console.group('-> nova');
	// https://docs.nova.app/api-reference/environment/
	console.log(nova);
	console.log(Object.getPrototypeOf(nova));
	// properties
	console.log(nova.assistants);
	console.log(nova.clipboard);
	console.log(nova.commands);
	console.log(nova.config);
	console.log(nova.credentials);
	console.log(nova.crypto);
	console.log(nova.environment);
	console.log(nova.extension);
	console.log(nova.fs);
	console.log(nova.locales);
	console.log(nova.notifications);
	console.log(nova.path);
	console.log(nova.subscriptions);
	console.log(nova.systemVersion);
	console.log(nova.version);
	console.log(nova.versionString);
	console.log(nova.workspace);
	// methods
	console.log(nova.beep());
	console.log(nova.localize('run'));
	console.log(nova.isReleasedVersion());
	console.log(nova.inDevMode());
	console.log(nova.openConfig);
	console.log(nova.openURL);
	console.groupEnd();

	// vars
	console.group('-> this');
	console.log(this);
	for (const name in this) {
		console.log(name);
	}
	console.groupEnd();
}

function deactivate(): void {
	console.log('Deactivated!');
}

module.exports = exports = {
	activate,
	deactivate,
};
