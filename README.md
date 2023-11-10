# Pixie

Pixie Game is a 2D RPG developed using the Love2D framework and Lua programming language. Drawing inspiration from classics like "The Legend of Zelda" and the charming farming simulator "Stardew Valley," Pixie Game embarks on a journey to capture the essence of adventure, exploration, and community building in a whimsical 2D world.

![image](https://github.com/violetverve/Pixie/assets/92580927/23c0063d-7e2a-4504-b2de-56767ab79127)


## How to Run

1. **Download and Install Love2D:**
   - Download and install Love2D from the [official website](https://love2d.org/).

2. **Clone the Repository:**
   - Open your terminal or command prompt.
   - Navigate to the directory where you want to clone the project.
   - Run the following command:
     ```bash
     git clone https://github.com/violetverve/Pixie
     ```
3. **Run the Game:**
   - The easiest way to run the game is to drag the folder onto either `love.exe` or a shortcut to `love.exe`. Remember to drag the folder containing `main.lua`, and not `main.lua`.
   - Other methods are described on the [Love2D wiki](https://love2d.org/wiki/Getting_Started).
   
## What is Implemented

During a relatively short development period, the team successfully implemented essential features for Pixie Game:

- **Camera Controls:** Established dynamic camera controls to enhance the gaming experience, ensuring player immersion. The camera seamlessly tracks the player's movements and adjusts to the world's boundaries.
- **Player Movement:** Developed responsive controls, ensuring smooth navigation through the enchanting 2D world. Navigate with the `Arrow` keys
- **World Map:** Developed a multi-layered tiled world map, adding depth and complexity to the game environment.
- **Pickup and Inventory Systems:** Enabled player interaction with various items and organized collected items through an intuitive inventory system. The navigation goes with the `WASD` keys. Players can freely relocate the items in inventory, and remove them: one with the `T` key or the whole stack with the `R` key. 
- **Weather Dynamics:** Implemented dynamic weather conditions, including cloudy and sunny weather.
- **Day-Night Shift with Shaders:** Achieved a transition between day and night with shader effects.
- **Colliders with Objects:** Enhanced environmental interaction with colliders on objects based on their position and height on the map.
- **Map Switching System:** Implemented a system for switching between different maps, offering diverse and expansive gameplay.

![image](https://github.com/violetverve/Pixie/assets/92580927/20e3c703-0a25-45d6-87ac-f9d7d501e5a0)
![image](https://github.com/violetverve/Pixie/assets/92580927/a690c0e0-2bba-40cb-8f6c-cbf1f5fb2a03)
![image](https://github.com/violetverve/Pixie/assets/92580927/086b232f-745d-431c-941f-b194afa817ad)
![image](https://github.com/violetverve/Pixie/assets/92580927/d271a7b8-df24-483e-8b19-ed3af736777f)
![image](https://github.com/violetverve/Pixie/assets/92580927/e861d8af-cbca-4dc4-981f-f7865c523b22)




## Libraries
- **push:** Resolution-handling for consistent visuals across different screens.
- **anim8:** Animation management for smooth sprite movement.
- **Class:** Object-oriented programming to structure game entities.
- **wf (windfield):** Physics library for collision detection and rigid bodies.
- **camera:** Camera system implementation for dynamic player views.
- **sti:** Handles Tiled map files for easy map creation and updates.
- **vector (hump):** Provides vector operations for movement and positioning.


## Acknowledgments

- Tutorials on Love2D, Lua by [Challacade](https://www.youtube.com/@Challacade)
- CS50’s Introduction to Game Development [Course](https://pll.harvard.edu/course/cs50s-introduction-game-development)
- Zelda-like tilesets and sprites by [ArMM1998](https://opengameart.org/content/zelda-like-tilesets-and-sprites)
- Food assets by [ARoachIFoundOnMyPillow](https://opengameart.org/content/16x16-food)


