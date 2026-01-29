# Biology-inspired Frequency Modulation for Full-body Synthetic Molecular Communication

This repository contains the evaluation and plotting code from the paper:

*Lisa Y. Debus and Falko Dressler, "Biology-inspired Frequency Modulation for Full-body Synthetic Molecular Communication," Proceedings of IEEE International Conference on Communications (ICC 2026), Glasgow, United Kingdom, May 2026. (to appear)*

## Description

Molecular communication (MC) is a step towards the future internet of bio-nano things (IoBNT) and a possible connection between life sciences and engineering for personalized medicine. To achieve this goal, we have to enable reliable communication through the human circulatory system (HCS). In this work, we introduce a novel frequency modulation (FM)-based communication approach for full-body MC. The presented approach encapsulates two different information states in an oscillating system inspired by the hypothalamic–pituitary–adrenal (HPA) axis of the human endocrine system. While the primary oscillation is produced by changing a feedback delay of one of the involved molecules, the secondary oscillation is driven by a changing intensity of the same molecule. We qualitatively compare our approach with amplitude modulation-based communication through the HCS and discuss its benefits for long-term MC-based monitoring in IoBNT applications.

## Usage

The directory `hpa` contains the MATLAB script `hpa_dde.m` with which you can produce Figure 1 from the paper showing the hormone levels of adrenocorticotropic hormone (ACTH), corticotropin-releasing hormone (CRH), and glucocorticoids,
cortisol (CORT) in humans over a day.
The used mathematical model is based on 

*J. J. Walker, J. R. Terry, and S. L. Lightman, "Origin of Ultradian Pulsatility in the Hypothalamic–pituitary–adrenal Axis," Proceedings of the Royal Society of London B: Biological Sciences, vol. 277, no. 1688, pp. 1627–1633, Jun. 2010.*

The directory `synthetic` contains MATLAB scripts to run the FM- and AM-based full-body communication as described in the paper and plot all figures shown therein.
To perform the evaluation, simply run the file `body_dde.m`.


## Contact Information

Lisa Y. Debus, Telecommunication Networks Group (TKN) at the School of Electrical Engineering and Computer Science, TU Berlin

[![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github)](https://github.com/lyDebus)
[![Email](https://img.shields.io/badge/Email-email-D14836?logo=gmail&logoColor=white)](mailto:debus@ccs-labs.org)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Lisa-blue?logo=linkedin&style=flat-square)](https://www.linkedin.com/in/lisa-yvonne-debus-844876127/)
[![Website Badge](https://img.shields.io/badge/Website-Homepage-blue?logo=web)](https://www.tkn.tu-berlin.de/team/debus/)
