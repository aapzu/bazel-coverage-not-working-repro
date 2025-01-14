def _batch_name_from_index(batch_prefix, index):
    return "%s_%s" % (batch_prefix, index)

def _ceil(n):
    if (type(n) == "float"):
        return int(n) + 1
    else:
        return n

def split_srcs_to_batches(srcs, batch_prefix, batch_size, min_batch_size):
    """
    Split a list of source files to multiple batches based on prefix and number of files per batch

    Args:
        srcs: the list of source files to split
        batch_prefix: the prefix to user for each batch. This is amended with a batch index for each batch
        batch_size: the number of files to add per batch
        min_batch_size: mininum number of files per batch

    Returns:
        dictionary of batch name to list of batch source files
    """
    batch_count = _ceil(len(srcs) / batch_size)
    size_cutoff = max(_ceil(len(srcs) / batch_count), min_batch_size)
    batch_index = 0
    batches = {}
    for idx, file in enumerate(sorted(srcs)):
        if idx % size_cutoff == 0:
            batch_index = batch_index + 1
            batches[_batch_name_from_index(batch_prefix, batch_index)] = []
        batches[_batch_name_from_index(batch_prefix, batch_index)].append(file)

    return batches
