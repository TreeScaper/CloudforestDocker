import { GalaxyData } from './js/modules/galaxy_data.js';

/**
 * Mediator pattern for application. 
 * @param {*} conf_obj 
 */

var CloudForest = (function (app) {
    app.event_debug = true;
    app.events = {};

    /**
     * Allows objects to subscribe to an event.
     * @param event name
     * @param fn call back function for event
     * @returns {subscribe}
     */
    app.subscribe = function (event, fn) {
        if (!app.events[event]) {
            app.events[event] = [];
        }
        app.events[event].push({
            context: this,
            callback: fn
        });
        return this;
    };

    /**
     * Unsubscribes from the event queue
     * @param event
     * @param fn
     */
    app.unsubscribe = function (event) {
        app.event[event].filter(function (cv) {
            return this === cv.context;
        }.bind(this));
    };


    /**
     * Allows objects to broadcast the occurrence of an event.
     * All subscribers to the event will have their callback functions
     * called.
     */
    app.publish = function (event) {
        var args, subscription;

        if (!app.events[event]) {
            return false;
        }
        args = Array.prototype.slice.call(arguments, 1);

        if (app.event_debug) {
            console.log('APP PUBLISH: ' + event + ' ARGS: ' + args);
        }

        app.events[event].map(function (cv) {
            subscription = cv;
            subscription.callback.apply(subscription.context, args);
        });
        return this;
    };

    /**
     * Adds the subscribe and publish functions to an object
     * @param obj
     */
    app.installTo = function (obj) {
        obj.subscribe = app.subscribe;
        obj.publish = app.publish;
        obj.unsubscribe = app.unsubscribe;
    };



    app.init = function (confObj) {
        confObj.subscribe = app.subscribe;
        confObj.publish = app.publish;
        confObj.unsubscribe = app.unsubscribe;
        this.installTo(GalaxyData(confObj));
        this.publish('FooFoo');
    }

    return {
        run: function (confbj) {
            app.init(confbj);
        }
    }
}(CloudForest || {}));


export { CloudForest }