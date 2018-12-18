## LSTM Backpropagation Module
*a bp module for 1 LSTM cell*
___
This module generates `TIMESTEP` delta blocks and calculate weights & biases for 1 cell.
The interconnections between cascaded delta blocks are achieved using 5 wires: `d_gates`, `d_d_h_prev_pass`, `d_d_c_prev_pass`, `d_d_h_next_pass`, `d_d_c_next_pass`. While other inputs for the delta blocks are taken from bp module's inputs.

    + TS = TIMESTEP
    + N  = Number of Inputs including h

### Wire Structure
**input ports** : `i_t` `i_h` `i_c` `i_a` `i_i` `i_f` `i_o` <br>
- each have length of `TIMESTEP x WIDTH`
- each of the ports have structures like this:<br>
**for example: the structure of i_c*<br>

|    T=TS    | ... | T=1 | T=0 |
| :--------: | :-: | :-: | :-: |
|    cT      | ... | c1  | c0  |

**input ports** : `i_x` <br>
- have length of `TIMESTEP x NUM x WIDTH`
**the structure of i_x*<br>

|            T=TS            |       |             T=0            |
| :------------------------: | :---: | :------------------------: |
| h  \|  xN  \|  ...  \|  x0 | ..... | h  \|  xN  \|  ...  \|  x0 |

**output ports** : `o_b` <br>
- have length of `4 x WIDTH` because a cell only has 4 bias values <br>
**the structure of o_b*<br>

| bo | bf | bi | ba |
| -- | -- | -- | -- |

**output ports** : `o_wa` `o_wi` `o_wf` `o_wo`  <br>
- each have length of `NUM x WIDTH` because a cell has 1 weight for each input <br>
**for example: the structure of o_wa*<br>

| wah | waN | ... | wa0 |
| --- | --- | --- | --- |

**wires** : `d_c_next_pass`  <br>
- have length of `TIMESTEP x WIDTH` <br>
**the structure of d_c_next_pass*<br>

| icN | ... | ic0 |  0  |
| --- | --- | --- | --- |

**wires** : `d_f_prev_pass`  <br>
- have length of `TIMESTEP x WIDTH` <br>
**the structure of d_f_prev_pass*<br>

|  0  | ifN | ... | if0 |
| --- | --- | --- | --- |

**wires** : `d_loss`  <br>
- have length of `TIMESTEP x WIDTH` <br>
**the structure of d_loss*<br>

| lossN | ... | loss0 |
| ----- | --- | ----- |

**wires** : `d_d_h_prev_pass` `d_d_c_prev_pass` `d_d_h_next_pass` `d_d_c_next_pass` <br>
- each have length of `TIMESTEP x WIDTH` <br>
**for example: the structure of d_d_h_prev_pass (top) & d_d_h_next_pass (bottom)*<br>

|    |    |     |    |
| -- | -- | --- | -- |
|  0 | hT | ... | h1 |
| hT | .. | h1  | h0 |

**wires** : `d_gates` <br>
- have length of `4 x TIMESTEP x WIDTH` because each timestep has 4 δgates <br>
**the structure of d_gates*<br>

|            T=TS            |       |             T=0            |
| :------------------------: | :---: | :------------------------: |
| do  \|  df  \|  di  \|  da | ..... | do  \|  df  \|  di  \|  da |

**wires** : `o_mult_a` `o_mult_i` `o_mult_f` `o_mult_o` <br>
- each have length of `TIMESTEP x NUM x WIDTH` because wire holds multiplication values of input & δ in every timesteps <br>
**for example: the structure of o_mult_a*<br>

|            m\_h            |            m\_N            |  ...  |            m\_0            |
| :------------------------: | :------------------------: | :---: | :------------------------: |
|   T=TS  \|  ..  \|  T= 0   |   T=TS  \|  ..  \|  T= 0   |  ...  |   T=TS  \|  ..  \|  T= 0   |

**wires** : `da` `di` `df` `do` <br>
- each have length of `TIMESTEP x WIDTH` because there are each timestep has their own δgates <br>
**for example: the structure of da*<br>

| T=TS | ... | T=0 |
| ---- | --- | --- |

