<?php

 /*
  * MVC Template for Web Apps
  *
  * This is an MVC implementation written by Ben Yanke, written for PHP web apps.
  *
  * Originally Developed in PHP version 7
  *
  * LICENSE: Creative Commons: Attribution-ShareAlike 4.0 International
  *
  * @author     Ben Yanke <ben@benyanke.com>
  * @copyright  Ben Yanke
  * @license    https://creativecommons.org/licenses/by-sa/4.0/ CC Attribution-ShareAlike 4.0 International
  * @link       https://github.com/benyanke/mvc-php
  * @since      Version 0.1
  *
  */

  require 'vendor/autoload.php';

$app = new Silex\Application();

$app['debug'] = true;

$app->get('/', function() use ($app) {
    return "home page";
});

$app->get('/n', function() use ($app) {
    return "/n page";
});

$app->get('/posts.json', function() use ($app) {
    return "You've reached posts.json";
});

$app->get('/test/{id}', function (Silex\Application $app, $id) use ($app) {
    return "/test/\$id || \$id = '$id'";
});

$app->get('/{id}', function (Silex\Application $app, $id) use ($app) {
    return "CATCHALL<br />/\$id || \$id = '$id'";
});


$app->run();


