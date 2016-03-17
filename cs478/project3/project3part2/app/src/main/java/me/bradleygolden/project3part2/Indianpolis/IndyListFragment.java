package me.bradleygolden.project3part2.Indianpolis;

import android.app.ListFragment;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import me.bradleygolden.project3part2.R;

/**
 * Created by bradleygolden on 3/16/16.
 */
public class IndyListFragment extends ListFragment {
    private ListSelectionListener mListener = null;
    public static String[] mIndyAttractionsArray;
    public static String[] mIndyAttractionsURLArray;

    // Callback interface that allows this Fragment to notify the AttractionViewerActivity when
    // user clicks on a List Item
    public interface ListSelectionListener {
        public void onListSelection(int index);
    }

    // Called when the user selects an item from the List
    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {

        // Indicates that the selected item has been clicked
        getListView().setItemChecked(position, true);

        // Inform the AttractionViewer that the item at position has been selected
        mListener.onListSelection(position);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {

        super.onActivityCreated(savedInstanceState);

        try {
            // Set the listener for communication with the Attractions Web View
            mListener = (ListSelectionListener) getActivity();
        } catch (ClassCastException e) {
            throw new ClassCastException(getActivity().toString() + " must implement OnListSelectionListener");
        }

        // Allow one selection at a time
        getListView().setChoiceMode(ListView.CHOICE_MODE_SINGLE);

        // Retain the state of this fragment
        setRetainInstance(true);

        mIndyAttractionsArray = getResources().getStringArray(R.array.indy_attractions);
        mIndyAttractionsURLArray = getResources().getStringArray(R.array.indy_attraction_urls);

        // Set the list adapter for the ListView
        setListAdapter(new ArrayAdapter<String>(getActivity(),
                R.layout.list_item, mIndyAttractionsArray));
    }
}
