__author__ = 'charlie'
import numpy as np
import os
import random
from six.moves import cPickle as pickle
from tensorflow.python.platform import gfile
import glob

import TensorflowUtils as utils



def read_dataset(data_dir):
    pickle_filename = "AWVFD-2.pickle"
    pickle_filepath = os.path.join(data_dir, pickle_filename)
    if not os.path.exists(pickle_filepath):
        #utils.maybe_download_and_extract(data_dir, DATA_URL, is_zipfile=True)
        SceneParsing_folder = "AWVFD-2/"
        result = create_image_lists(os.path.join(data_dir, SceneParsing_folder))
        print ("Pickling ...")
        with open(pickle_filepath, 'wb') as f:
            pickle.dump(result, f, pickle.HIGHEST_PROTOCOL)
    else:
        print ("Found pickle file!")

    with open(pickle_filepath, 'rb') as f:
        result = pickle.load(f)
        training_records = result['training']
        validation_records = result['validation']
        del result

    return training_records, validation_records


def create_image_lists(image_dir):
    if not gfile.Exists(image_dir):
        print("Image directory '" + image_dir + "' not found.")
        return None
    directories = ['training', 'validation']
    image_list = {}

    for directory in directories:
        file_list = []
        #print(directory)
        image_list[directory] = []
        file_glob = os.path.join(image_dir, "images", directory, '*.' + 'png')
        #print('wojiuyaoshishi,shishijiushishi111111111111111111111111')
        #print(file_glob)
        file_list.extend(glob.glob(file_glob))

        if not file_list:
            print('No files found')
        else:
            for f in file_list:
                filename = os.path.splitext(f.split("/")[-1])[0]
                #print('wojiuyaoshishi,shishijiushishi')
                #print(filename)
                annotation_file = os.path.join(image_dir, "annotations", directory, filename + '.png')
                if os.path.exists(annotation_file):
                    record = {'image': f, 'annotation': annotation_file, 'filename': filename}
                    image_list[directory].append(record)
                else:
                    print("Annotation file not found for %s - Skipping" % filename)

        random.shuffle(image_list[directory])
        no_of_images = len(image_list[directory])
        print ('No. of %s files: %d' % (directory, no_of_images))

    return image_list
