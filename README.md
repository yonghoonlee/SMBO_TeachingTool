# SMBO_TeachingTool

SMBO_TeachingTool: A modular code for teaching Surrogate Modeling-Based Optimization.

This code is designed for students to understand basic concept of Surrogate Modeling-Based Optimization.

## Author

[Yong Hoon Lee](mailto:ylee196@illinois.edu) <br />
[Engineering System Design Laboratory](http://systemdesign.illinois.edu) (PI: Professor [James T. Allison](mailto:jtalliso@illinois.edu)), <br />
University of Illinois at Urbana-Champaign

## Prerequisites

* MATLAB with Optimization and Global Optimization Toolboxes
* (optional for plot export) Ghostscript

## How to execute

* Run "main_SMBO.m" Script

* Specify the problem name (= problem folder name) in the "prob" variable before run the script to solve a different problem.

  - Example (in "main_SMBO.m" file):
    ```MATLAB
    prob = 'AckleyFn';
    ```

## How to create a customized problem

* Create a folder with problem name (e.g., "MatyasFn").

* Create a MATLAB function file: "obj.m" in the created problem folder.

  - Example:
    ```MATLAB
    function f = obj(x)
        f = 0.26*(x(1)^2 + x(2)^2) - 0.48*x(1)*x(2);
    end
    ```

* Create a MATLAB function file: "conf.m" in the created problem folder.

  - Example:
    ```MATLAB
    function pc = conf()
        pc.nvar = 2;                % Number of variables
        pc.lb = [-10,-10];          % Lower bounds
        pc.ub = [5,5];              % Upper bounds
        pc.fs_g = 0.75;             % Shrink factor for global sample range
        pc.xtrue = [0,0];           % True soltuion in x (for comparison)
        pc.ftrue = 0;               % True solution in f (for comparison)
    end
    ```
