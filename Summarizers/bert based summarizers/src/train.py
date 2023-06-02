#!/usr/bin/env python
"""
    Main training workflow
"""
from __future__ import division

import argparse
import os
from others.logging import init_logger
from train_abstractive import build_abstractive, summarize_by_abstractive, validate_abs, train_abs, baseline, test_abs, test_text_abs
from train_extractive import summarize_by_extractive, train_ext, validate_ext, test_ext, test_text_ext, build_extractive
from models.data_loader import load_one_text


def str2bool(v):
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    elif v.lower() in ('no', 'false', 'f', 'n', '0'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')


    
def preprocess_input_for_extractive(paragraph):
    sentences = paragraph.split(". ")
    transformed_text = ". [CLS] [SEP] ".join(sentences)
    return transformed_text

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-task", default='ext', type=str, choices=['ext', 'abs'])
    parser.add_argument("-encoder", default='bert', type=str, choices=['bert', 'baseline'])
    parser.add_argument("-mode", default='train', type=str, choices=['train', 'validate', 'test', 'test_text'])
    parser.add_argument("-bert_data_path", default='../bert_data_new/cnndm')
    parser.add_argument("-model_path", default='../models/')
    parser.add_argument("-result_path", default='../results/cnndm')
    parser.add_argument("-temp_dir", default='../temp')
    parser.add_argument("-text_src", default='')
    parser.add_argument("-text_tgt", default='')

    parser.add_argument("-batch_size", default=140, type=int)
    parser.add_argument("-test_batch_size", default=200, type=int)
    parser.add_argument("-max_ndocs_in_batch", default=6, type=int)

    parser.add_argument("-max_pos", default=512, type=int)
    parser.add_argument("-use_interval", type=str2bool, nargs='?',const=True,default=True)
    parser.add_argument("-large", type=str2bool, nargs='?',const=True,default=False)
    parser.add_argument("-load_from_extractive", default='', type=str)

    parser.add_argument("-sep_optim", type=str2bool, nargs='?',const=True,default=False)
    parser.add_argument("-lr_bert", default=2e-3, type=float)
    parser.add_argument("-lr_dec", default=2e-3, type=float)
    parser.add_argument("-use_bert_emb", type=str2bool, nargs='?',const=True,default=False)

    parser.add_argument("-share_emb", type=str2bool, nargs='?', const=True, default=False)
    parser.add_argument("-finetune_bert", type=str2bool, nargs='?', const=True, default=True)
    parser.add_argument("-dec_dropout", default=0.2, type=float)
    parser.add_argument("-dec_layers", default=6, type=int)
    parser.add_argument("-dec_hidden_size", default=768, type=int)
    parser.add_argument("-dec_heads", default=8, type=int)
    parser.add_argument("-dec_ff_size", default=2048, type=int)
    parser.add_argument("-enc_hidden_size", default=512, type=int)
    parser.add_argument("-enc_ff_size", default=512, type=int)
    parser.add_argument("-enc_dropout", default=0.2, type=float)
    parser.add_argument("-enc_layers", default=6, type=int)

    # params for EXT
    parser.add_argument("-ext_dropout", default=0.2, type=float)
    parser.add_argument("-ext_layers", default=2, type=int)
    parser.add_argument("-ext_hidden_size", default=768, type=int)
    parser.add_argument("-ext_heads", default=8, type=int)
    parser.add_argument("-ext_ff_size", default=2048, type=int)

    parser.add_argument("-label_smoothing", default=0.1, type=float)
    parser.add_argument("-generator_shard_size", default=32, type=int)
    parser.add_argument("-alpha",  default=0.6, type=float)
    parser.add_argument("-beam_size", default=5, type=int)
    parser.add_argument("-min_length", default=15, type=int)
    parser.add_argument("-max_length", default=150, type=int)
    parser.add_argument("-max_tgt_len", default=140, type=int)



    parser.add_argument("-param_init", default=0, type=float)
    parser.add_argument("-param_init_glorot", type=str2bool, nargs='?',const=True,default=True)
    parser.add_argument("-optim", default='adam', type=str)
    parser.add_argument("-lr", default=1, type=float)
    parser.add_argument("-beta1", default= 0.9, type=float)
    parser.add_argument("-beta2", default=0.999, type=float)
    parser.add_argument("-warmup_steps", default=8000, type=int)
    parser.add_argument("-warmup_steps_bert", default=8000, type=int)
    parser.add_argument("-warmup_steps_dec", default=8000, type=int)
    parser.add_argument("-max_grad_norm", default=0, type=float)

    parser.add_argument("-save_checkpoint_steps", default=5, type=int)
    parser.add_argument("-accum_count", default=1, type=int)
    parser.add_argument("-report_every", default=1, type=int)
    parser.add_argument("-train_steps", default=1000, type=int)
    parser.add_argument("-recall_eval", type=str2bool, nargs='?',const=True,default=False)


    parser.add_argument('-visible_gpus', default='-1', type=str)
    parser.add_argument('-gpu_ranks', default='0', type=str)
    parser.add_argument('-log_file', default='../logs/cnndm.log')
    parser.add_argument('-seed', default=666, type=int)

    parser.add_argument("-test_all", type=str2bool, nargs='?',const=True,default=False)
    parser.add_argument("-test_from", default='')
    parser.add_argument("-test_start_from", default=-1, type=int)

    parser.add_argument("-train_from", default='')
    parser.add_argument("-report_rouge", type=str2bool, nargs='?',const=True,default=True)
    parser.add_argument("-block_trigram", type=str2bool, nargs='?', const=True, default=True)

    args = parser.parse_args()
    args.gpu_ranks = [int(i) for i in range(len(args.visible_gpus.split(',')))]
    args.world_size = len(args.gpu_ranks)
    os.environ["CUDA_VISIBLE_DEVICES"] = args.visible_gpus

    init_logger(args.log_file)
    device = "cpu" if args.visible_gpus == '-1' else "cuda"
    device_id = 0 if device == "cuda" else -1
    sentence = """this Terry Jones had a love of the absurd that contributed much to the anarchic humour of Monty Python's Flying Circus. His style of visual comedy, leavened with a touch of the surreal, inspired many comedians who followed him. It was on Python that he honed his directing skills, notably on Life of Brian and The Meaning of Life. A keen historian, he wrote a number of books and fronted TV documentaries on ancient and medieval history. Terence Graham Parry Jones was born in Colwyn Bay in north Wales on 1 February 1942. His grandparents ran the local amateur operatic society and staged Gilbert and Sullivan concerts on the town's pier each year His family moved to Surrey when he was four but he always felt nostalgic about his native land. "I couldn't bear it and for the longest time I wanted Wales back," he once said. "I still feel very Welsh and feel it's where I should be really." After leaving the Royal Grammar School in Guildford, where he captained the school, he went on to read English at St Edmund Hall, Oxford. However, as he put it, he "strayed into history", the subject in which he graduated. While at Oxford he wrote sketches for the Oxford Revue and performed alongside a fellow student, Michael Palin."""
                  
    # sentence = preprocess_input_for_extractive(sentence)
    gen = load_one_text(args, sentence, device)

    # extractive = build_extractive(args)
    # print(summarize_by_extractive(extractive, gen))

    abstractive = build_abstractive(args)
    print(summarize_by_abstractive(abstractive, gen))
