"""Plots a map based on sensor readings from a csv file"""

import sys
import matplotlib
import matplotlib.pyplot as plt
from matplotlib import patches
import numpy as np

MAX_HISTORY = 50


class MapDrawer:
    """Represents the drawing activity"""

    car_width = 0
    car_length = 0
    wheel_width = 0
    wheel_diameter = 0
    num_sensors = 0
    positions = []
    data_mem = []
    ax = None
    fig = None

    def __init__(self):
        matplotlib.use("QtAgg")
        self.fig, self.ax = plt.subplots()

        # Set the dimensions of the car chassis (in cm)
        self.car_width = 20
        self.car_length = 40

        # Set the width and diameter of the wheel module in centimeters
        self.wheel_width = 7.5
        self.wheel_diameter = 8.5

        # Set positions to plot the wheel module
        self.positions = [(10, 10), (10, -17.5), (-17.5, 10), (-17.5, -17.5)]

        self.num_sensors = int(sys.argv[2])
        self.data_mem = np.zeros((0, self.num_sensors, 2))

    def main(self):
        """
        Runs the main drawing cycle
        """
        with open(sys.argv[1], "r") as file:
            while True:
                # Read data from the file
                data = self.get_input(file)
                self.data_mem = np.append(self.data_mem, data, 0)[-MAX_HISTORY:]

                # Get current axis
                ax = plt.gca()

                # Clear previous plot
                ax.clear()

                # Draw the car chassis with a specific face color
                self.draw_car_chassis(facecolor="lightblue")

                # Plot the wheel module at different positions
                for position in self.positions:
                    self.plot_wheel(position[0], position[1])

                # Plot data points from memory after recent input
                self.update_data(ax)

                # Set the aspect ratio to be equal, so the wheel doesn't get distorted
                ax.set_aspect("equal", adjustable="box")

                # Set the axis limits based on the ultrasonic range
                ax.set_xlim(-450, 450)
                ax.set_ylim(-450, 450)

                # Show the plot
                plt.show(block=False)
                plt.pause(1 / 60)

    def draw_car_chassis(self, facecolor="blue"):
        """
        Draws car chasis on given axes.
        """

        half_width = self.car_width / 2
        half_length = self.car_length / 2

        vertices = np.array(
            [
                [-half_width, -half_length],
                [half_width, -half_length],
                [half_width, half_length],
                [-half_width, half_length],
                [-half_width, -half_length],
            ]
        )

        self.ax.fill_between(vertices[:, 0], vertices[:, 1], color=facecolor)

        self.ax.set_aspect("equal", adjustable="box")
        self.ax.set_xlabel("X-axis (cm)")
        self.ax.set_ylabel("Y-axis (cm)")
        self.ax.set_title("2D Car Mapping")

    # Function to plot a wheel module
    def plot_wheel(self, x, y):
        """
        Plots car wheels on current axes
        """
        vertices = [
            (x, y),
            (x + self.wheel_width, y),
            (x + self.wheel_width, y + self.wheel_diameter),
            (x, y + self.wheel_diameter),
            (x, y),
        ]
        wheel = patches.Polygon(vertices, edgecolor="none", facecolor="blue")
        self.ax.add_patch(wheel)

    def update_data(self, ax):
        """
        Update axes with current data
        """
        data_mem_plt = self.data_mem.reshape((-1, 2))
        alphas = np.repeat(
            np.linspace(0.01, 1, self.data_mem.shape[0]) ** 2,
            data_mem_plt.shape[0] / self.data_mem.shape[0],
        )
        ax.scatter(
            data_mem_plt[:, 0], data_mem_plt[:, 1], color="red", alpha=alphas, s=4
        )

    def get_input(self, file):
        """
        Reads an input line from provided file.

        it's expected to be in csv format.
        WARNING! this function will block until a valid line is read
        """
        while True:
            data = list(
                map(
                    lambda x: float(x or 0),
                    file.readlines()[-1].strip().split(","),
                )
            )
            coords, trans = data[:-2], data[-2:]
            if len(coords) != 2 * self.num_sensors:
                plt.pause(0.005)
            else:
                break

        return np.array(coords).reshape([1, self.num_sensors, 2])


if __name__ == "__main__":
    MapDrawer().main()
