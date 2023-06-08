from __future__ import division
import torch

# constructing different penalty functions used in a beam search algorithm
# Each length penalty function modifies the log probabilities of the beam candidates to favor shorter or longer sequences based on different strategies or formulas.
class PenaltyBuilder(object):
    """
    Returns the Length and Coverage Penalty function for Beam Search.

    Args:
        length_pen (str): option name of length pen
        cov_pen (str): option name of cov pen
    """

    def __init__(self,  length_pen):
        self.length_pen = length_pen

    def length_penalty(self):
        if self.length_pen == "wu":
            return self.length_wu
        elif self.length_pen == "avg":
            return self.length_average
        else:
            return self.length_none

    """
    Below are all the different penalty terms implemented so far
    """


    def length_wu(self, beam, logprobs, alpha=0.):
        """
        NMT length re-ranking score from
        "Google's Neural Machine Translation System" :cite:`wu2016google`.
        """
        # It takes beam, logprobs, and an optional parameter alpha as inputs.
        # It calculates a modifier value based on the length of the beam sequence (beam.next_ys) and the alpha value.
        # It returns the log probabilities divided by the modifier value, effectively applying the length penalty.

        modifier = (((5 + len(beam.next_ys)) ** alpha) /
                    ((5 + 1) ** alpha))
        return (logprobs / modifier)

    def length_average(self, beam, logprobs, alpha=0.):
        """
        Returns the average probability of tokens in a sequence.
        So lengthy sentences score got normalized when compared when short sentences
        """
        return logprobs / len(beam.next_ys)

    def length_none(self, beam, logprobs, alpha=0., beta=0.):
        """
        Returns unmodified scores.
        """
        # It simply returns the log probabilities without any modification.
        return logprobs