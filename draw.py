import matplotlib
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np
import pandas as pd
import sys

MAX_HISTORY=50

car_width = 0
car_length = 0
wheel_width = 0
wheel_diameter = 0
num_sensors = 0
positions = []
data_mem = []


def main():
    init()
    loop()
    clean_up()

def init():
    global car_width, car_length, wheel_width, wheel_diameter, positions, num_sensors, data_mem

    matplotlib.use('QtAgg')
    f = plt.figure()

    # Set the dimensions of the car chassis (in cm)
    car_width = 20
    car_length = 40

    # Set the width and diameter of the wheel module in centimeters
    wheel_width = 7.5
    wheel_diameter = 8.5

    # Set positions to plot the wheel module
    positions = [(10, 10), (10, -17.5), (-17.5, 10), (-17.5, -17.5)]

    num_sensors = int(sys.argv[2])
    data_mem = np.zeros((0, num_sensors, 2))
    
def loop():
    global data_mem

    with open(sys.argv[1], 'r') as file:
        while True:
            # Read data from the file
            data = get_input(file)
            data_mem = np.append(data_mem, data, 0)[-MAX_HISTORY:]

            # Get current axis
            ax = plt.gca()

            # Clear previous plot
            ax.clear()

            # Draw the car chassis with a specific face color
            draw_car_chassis(ax, car_width, car_length, facecolor='lightblue')

            # Plot the wheel module at different positions
            for position in positions:
                plot_wheel(ax, wheel_width, wheel_diameter, position[0], position[1])

            # Plot data points from memory after recent input
            plot_data(ax)

            # Set the aspect ratio to be equal, so the wheel doesn't get distorted
            ax.set_aspect('equal', adjustable='box')

            # Set the axis limits based on the ultrasonic range
            ax.set_xlim(-450, 450)
            ax.set_ylim(-450, 450)

            # Show the plot
            plt.show(block=False)
            plt.pause(1/60)

def clean_up():
    pass
        
def draw_car_chassis(ax, width, length, facecolor='blue'):
    '''
    Draws car chasis on given axes.
    '''

    half_width = width / 2
    half_length = length / 2

    vertices = np.array([[-half_width, -half_length],
                         [half_width, -half_length],
                         [half_width, half_length],
                         [-half_width, half_length],
                         [-half_width, -half_length]])

    ax.fill_between(vertices[:, 0], vertices[:, 1], color=facecolor)

    ax.set_aspect('equal', adjustable='box')
    ax.set_xlabel('X-axis (cm)')
    ax.set_ylabel('Y-axis (cm)')
    ax.set_title('2D Car Mapping')

# Function to plot a wheel module
def plot_wheel(ax, width, height, x, y):
    '''
    Plots car wheels on current axes
    '''
    vertices = [(x, y), (x + width, y), (x + width, y + height), (x, y + height), (x, y)]
    wheel = patches.Polygon(vertices, edgecolor='none', facecolor='blue')
    ax.add_patch(wheel)

def get_input(file):
    '''
    Reads an input line from provided file.

    it's expected to be in csv format.
    WARNING! this function will block until a valid line is read
    '''
    while True:
        data = list(map(lambda x: float(x or 0), file.readline().strip().split(',')))
        coords, trans = data[:-2], data[-2:]
        print(trans)
        if len(coords) != 2 * num_sensors:
            plt.pause(0.005)
        else:
            break

    return np.array(coords).reshape(1, num_sensors, 2)


def plot_data(ax):
    global data_mem

    data_mem_plt = data_mem.reshape((-1, 2))
    alphas = np.repeat(np.linspace(0.01, 1, data_mem.shape[0]) ** 2, data_mem_plt.shape[0] / data_mem.shape[0])
    ax.scatter(data_mem_plt[:, 0], data_mem_plt[:, 1], color='red', alpha=alphas, s=4)
    return

if __name__ == '__main__':
    main()

