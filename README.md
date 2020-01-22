# Giphy

A simple app for showing gif images, it fetch images from giphy `trending` api, and when you play each giphy after 10 seconds it randomly shows another giphy by using giphy `random` api.   

This app has no external dependency.  

I've used `Combine` and `SwiftUI` in this project. these are new frameworks announced by Apple in WWDC 2019.  


## Design Patterns

[MVVM](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel), [Reactive Programming](https://en.wikipedia.org/wiki/Reactive_programming), [Coordinator](http://khanlou.com/2015/10/coordinators-redux/)

  

- I used MVVM since it helps to keep the data flow separated from the view itself, as a result, we have more readable and scalable code.

- Reactive Programming saves us from "callback hell", it also saves time in solving complex data flow problems and provides a unique interface for the app modules

- Coordinator pattern keeps the modules separated, each module of the app doesn't know anything about the other one, it means they are testable and reusable, it also provides a very clean look for each module so by looking into a coordinator you can see what the module does and how the data flow works.

  

## Project Structure

  

- This project contains two coordinators `AppCoordinator` and `GiphyCoordinator` as a child, by adding more modules we add more coordinators

- `WebAPI` is responsible for performing all web requests at the moment we have one group of endpoints called `GiphyEndpoint`

- `FileRepository` is designed to read and write data from/to the disk in a thread-safe way

- `GiphyRepository` is providing all giphy related operators and data, it also keeps the loaded giphy list

- lastly, we have `Views` and `ViewModels` for each part and helper files in the `Utilities` group



I decided to use `mp4` for an animated version of Gif files since it's supported on iOS and macOS natively and also smaller so needs less storage and downloads faster

  

## Usage


You can simply open the project with Xcode and run the app, this project has no external dependency.

You can target iOS, iPadOS, and macOS
