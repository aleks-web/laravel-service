<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/frontend/landing/script', function (Request $request) {
    $origin = preg_replace("#^[^:/.]*[:/]+#i", "", request()->header('Origin'));
    $content = view('sites.scripts.main', [
        'origin' => $origin
    ]);

    return response($content)
        ->header('Access-Control-Allow-Origin', '*')
        ->header('Content-Type', 'application/javascript');
})->name('sites.script');

Route::get('/test', function (Request $request) {
    dd();
});
