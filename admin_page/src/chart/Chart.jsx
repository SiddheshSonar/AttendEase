import React, { useState, useEffect, useMemo } from 'react';
import { Bar } from 'react-chartjs-2';
import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    BarElement,
    Title,
    Tooltip,
    Legend,
} from 'chart.js';
import { pb } from '../login_page/Login';

ChartJS.register(
    BarElement,
    CategoryScale,
    LinearScale,
    Tooltip,
    Legend,
    Title,
);

const Chart = (props) => {
    const [crec, setCrec] = useState([]);

    useEffect(() => {
        async function fetchData() {
            const response = await pb.collection('courses').getFullList({});
            setCrec(response);
        }
        fetchData();
    }, []);

    const subnames = useMemo(() => crec.map((sub) => sub.course_name), [crec]);
    const totalLecs = useMemo(() => crec.map((sub) => sub.lectures), [crec]);

    const info = props.record;
    let attended = [];

    if (info.attendance) {
        attended = subnames.map(
            (subname) => (info.attendance[subname]?.length ?? 0)
        );
    }
    else {
      attended = Array(crec.length).fill(0)
    }

    const data = useMemo(() => {
      const percent = attended.map((num, idx) => {
        const total = totalLecs[idx];
        return ((num / total) * 100).toFixed(2) + '%';
      });
      const labels = subnames.map((subname, idx) => `${subname} (${percent[idx]})`);
      const percentageAttended = attended.map((count, index) => {
        return count / totalLecs[index];
      });

      return {
        labels: labels,
        datasets: [
          {
            label: 'lectures attended',
            data: attended,
            backgroundColor: percentageAttended.map((percentage) =>
            percentage >= 0.75 ? '#00FF00' : 'red')
          },
          {
            label: 'total lectures',
            data: totalLecs,
            backgroundColor: '#0059ff'
          },
        ],
      };
    }, [attended, subnames, totalLecs]);
    

    const options = useMemo(
        () => ({
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                      font: {
                        size: 15,
                      },
                      color: 'white', 
                    },
                },
                title: {
                    display: true,
                    text: `${info.name}'s Attendance Report`,
                    font: {
                        size: 20,
                    },
                    color: "#FFFFFF"
                },
            },
            scales: {
                x: {
                    ticks: {
                        autoSkip: false,
                        font: {
                          size: 15,
                      },
                      color: "#FFFFFF"
                    },
                },
                y: {
                    beginAtZero: true,
                    ticks: {
                      font: {
                        size: 15,
                    },
                    color: "#FFFFFF"
                  },
                },
            },
            responsive: true,
            maintainAspectRatio: true,
            aspectRatio: 3, // set aspect ratio to adjust graph width and height
            maxDimensions: {
                width: 600, // set maximum width of graph
                height: 600, // set maximum height of graph
            },
        }),
        [info.name]
    );

    return (
        <div
            className='chart'
            style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
            }}
        >
            <Bar data={data} options={options} />
        </div>
    );
};

export default Chart;